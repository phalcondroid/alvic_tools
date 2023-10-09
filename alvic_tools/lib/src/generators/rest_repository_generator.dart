import 'package:alvic_tools/src/helpers/metadata_extractor.dart';
import 'package:alvic_tools_annotations/alvic_tools_annotations.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import '../visitor/model_visitor.dart';

class RestRepositoryGenerator extends GeneratorForAnnotation<RestRepository> {

  String url = '';
  
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep
  ) {
    final visitor = ModelVisitor();
  
    element.visitChildren(visitor); // Visits all the children of element in no particular order.

    final className = visitor.className; // EX: 'ModelGen' for 'Model'.

    final classBuffer = StringBuffer();

    url = annotation.peek('path')?.stringValue ?? '';

    classBuffer.writeln('class _$className implements $className {');

    resolveMethods(classBuffer, visitor.methods);

    classBuffer.writeln('}');

    return classBuffer.toString();
  }

  void resolveMethods(StringBuffer classBuffer, Map<String, Map<String, dynamic>> methods) {
    methods.forEach((methodName, methodData) {
      methodData["url"] = url + methodData["url"];

      classBuffer.writeln("@override");
      List<String> methodParams = [];
      methodData["params"].forEach((key, value) => methodParams.add(value["raw"].toString()));
      classBuffer.writeln("${methodData["return"]} $methodName(${methodParams.join(",")}) async {");

      classBuffer.writeln("\t HttpAdapter adapter = GetIt.I<HttpAdapter>();");

      bool asList = methodData["return"].toString().toLowerCase().contains("list");

      if (methodData["type"] == "get") {
        printForGetMethod(classBuffer, asList, methodData);
      }

      if (methodData["type"] == "post") {
        printForPostMethod(classBuffer, asList, methodData);
      }
      
      classBuffer.writeln("}");
    });
  }

  void printForPostMethod(StringBuffer classBuffer, bool asList, Map<String, dynamic> methodData) {
    String modelName = '';
    methodData["params"].forEach((key, Map<String, dynamic> value) { 
      if (value.containsKey("workingFor")) {
        modelName = MedatadaExtractor.cleanModelName(value['workingFor'].split(" ")[0].toString().trim());
      }
    });

    if (modelName.isEmpty) {
      classBuffer.writeln("throw const AlvicException('@workingFor annotation is mandatory');");
      return;
    }
    // String dirtyModel = ((methodData["params"]).where((e) { print("eelementiii -$e"); return e == "workingFor"; }).first.toString()).split(" ")[0];
    var headersAsMap = methodData["headers"].toString().trim().split(",").map((e) => 
      "'${e.trim()}': GetIt.I.get<AlvicContainer>().getContent('${e.trim()}')"
    ).toList();
    classBuffer.writeln("LocalStorageAdapter localAdapter = GetIt.I<LocalStorageAdapter>();");
    methodData["params"].forEach((key, Map<String, dynamic> value) {
      if ((value.containsKey("postRequestModel"))) {
        classBuffer.writeln(
          "adapter.save('${methodData["url"]}', [ ${value["name"]}.toJson() ], HttpOptions(headers: {${headersAsMap.join(",")}}));"
        );
        classBuffer.writeln("await localAdapter.clear('$modelName');");
      }
    });
    classBuffer.writeln("return true;");
  }

  void printForGetMethod(StringBuffer classBuffer, bool asList, Map<String, dynamic> methodData) {
    String modelName = MedatadaExtractor.cleanModelName(methodData["return"]);
    var httpOptionsMethodName = "HttpOptions";
    var addFilter = "";
    String startList = asList ? "List<" : "";
    String endList = asList ? ">" : "";
    String adapterMethod = asList ? "get" : "getOne";

    var queryParamsMap = {};
    httpOptionsMethodName = "HttpOptions";
    methodData["params"].forEach((key, Map<String, dynamic> value) {
      if ((value.containsKey("query"))) {
        queryParamsMap.addAll(value["query"]);
      }
      if (value.containsKey("path")) {
        methodData["url"] += "/\$" + value["name"] + "";
      }
      if ((value.containsKey("where"))) {
        addFilter = ".where(${value['name']}).toList()";
      }
    });

    List<String> httpOptionsParams = [];
    if (queryParamsMap.isNotEmpty) {
      httpOptionsParams.add('queries: $queryParamsMap');
    }
    if (methodData.containsKey("headers") && methodData["headers"].toString().isNotEmpty) {
      httpOptionsParams.add('headers: "${methodData["headers"]}"');
    }

    classBuffer.writeln("LocalStorageAdapter localAdapter = GetIt.I<LocalStorageAdapter>();");
    classBuffer.writeln("${startList}Map<String, dynamic>$endList rawResponse = await localAdapter.$adapterMethod('$modelName', const LocalStorageOptions());");
    classBuffer.writeln("if (rawResponse.isEmpty) {");
    classBuffer.writeln("rawResponse = await adapter.$adapterMethod(");
    classBuffer.writeln("'${methodData["url"]}',");
    classBuffer.writeln("$httpOptionsMethodName(${httpOptionsParams.join(",")})");
    classBuffer.writeln(");");
    classBuffer.writeln("await localAdapter.save('$modelName', ${asList ? 'rawResponse': '[rawResponse]'}, const LocalStorageOptions());");
    classBuffer.writeln("}");
    startList = asList ? "rawResponse.map((item) => " : "";
    endList = asList ? ").toList()$addFilter" : "";
    String listValue = asList ? "item" : "rawResponse";
    classBuffer.writeln("return $startList$modelName.fromJson($listValue)$endList;"); 
  }
}