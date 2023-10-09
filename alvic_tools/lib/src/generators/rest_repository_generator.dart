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
      methodData["url"] += url;

      classBuffer.writeln("@override");
      List<String> methodParams = [];
      methodData["params"].forEach((key, value) => methodParams.add(value["raw"].toString()));
      classBuffer.writeln("${methodData["return"]} $methodName(${methodParams.join(",")}) async {");

      String modelName = MedatadaExtractor.cleanModelName(methodData["return"]);
      bool asList = methodData["return"].toString().toLowerCase().contains("list");

      classBuffer.writeln("\t HttpAdapter adapter = GetIt.I<HttpAdapter>();");
      var queryParamsMap = {};
      var httpOptionsMethodName = "HttpGetOptions";
      if (methodData["type"] == "get") {
        httpOptionsMethodName = "HttpGetOptions";
        methodData["params"].forEach((key, Map<String, dynamic> value) {
          if ((value.containsKey("query"))) {
            queryParamsMap.addAll(value["query"]);
          }
          if (value.containsKey("path")) {
            methodData["url"] += "/\$" + value["name"] + "";
          }
        });
      }
      List<String> httpOptionsParams = [];
      if (queryParamsMap.isNotEmpty) {
        httpOptionsParams.add('queries: $queryParamsMap');
      }
      if (methodData.containsKey("sourceKey") && methodData["sourceKey"].toString().isNotEmpty) {
        httpOptionsParams.add('sourceKey: "${methodData["sourceKey"]}"');
      }

      String startList = asList ? "List<" : "";
      String endList = asList ? ">" : "";
      String adapterMethod = asList ? "get" : "getOne";

      classBuffer.writeln("${startList}Map<String, dynamic>$endList rawResponse = await adapter.$adapterMethod(");
      classBuffer.writeln("'${methodData["url"]}',");
      classBuffer.writeln("$httpOptionsMethodName(${httpOptionsParams.join(",")})");
      classBuffer.writeln(");");
      startList = asList ? "rawResponse.map((item) => " : "";
      endList = asList ? ").toList()" : "";
      String listValue = asList ? "item" : "rawResponse";
      classBuffer.writeln("return $startList$modelName.fromJson($listValue)$endList;");
      classBuffer.writeln("}");
    });
  }
}