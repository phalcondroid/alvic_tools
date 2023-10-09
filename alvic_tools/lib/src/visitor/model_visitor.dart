import 'package:alvic_tools/src/helpers/metadata_extractor.dart';
import 'package:alvic_tools_annotations/alvic_tools_annotations.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

class ModelVisitor extends SimpleElementVisitor<void> {

  late String className;
  final fields = <String, dynamic>{};
  final Map<String, dynamic> metaData = {};
  final Map<String, Map<String, dynamic>> methods = {};

  @override
  void visitConstructorElement(ConstructorElement element) {
    final elementReturnType = element.type.returnType.toString();
    className = elementReturnType.replaceFirst('*', '');
  }

  @override
  void visitFieldElement(FieldElement element) {
    final elementType = element.type.toString();
    fields[element.name] = elementType.replaceFirst('*', '');
    metaData[element.name] = element.metadata;
  }

  @override
  void visitMethodElement(MethodElement element) {
    String repoUrl = "";
    Map<String, Map<String, dynamic>> params = {};
    methods[element.name] = {
      "url": repoUrl,
    };
    methods[element.name]!["url"] += MedatadaExtractor.getUrlByType(element);
    if (element.metadata.first.toString().contains("@Get")) {
      methods[element.name]?.addAll({
        "sourceKey": MedatadaExtractor.getFromElement(element, Get, 'sourceKey'),
      });
    }
    
    element.parameters.forEach((paramElement) {
      params[paramElement.name] = {
        "raw": paramElement,
        "name": paramElement.name,
      };
      
      if (element.metadata.first.toString().contains("@Get")) {
        if (paramElement.metadata.first.toString().contains("@Path")) {
          if (!params[paramElement.name]!.containsKey("path")) {
            params[paramElement.name]?.addAll({ "path": "path" });
          }
        }
        if (paramElement.metadata.first.toString().contains("@Query")) {
          if (!params[paramElement.name]!.containsKey("query")) {
            params[paramElement.name]?.addAll({ "query": {} });
          }
          params[paramElement.name]?["query"]["'${paramElement.name}'"] = paramElement.name;
        }
      }
    });
    
    methods[element.name]?.addAll({
      "params": params,
      "type": MedatadaExtractor.getMethodType(element),
      "name": element.name,
      "return": element.declaration.returnType.toString(), 
    });
  }
}
