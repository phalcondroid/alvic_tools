import 'package:alvic_tools_annotations/alvic_tools_annotations.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

class MedatadaExtractor {
  static dynamic getFromElement(Element element, Type type, String field) {
    return TypeChecker.fromRuntime(type)
            .annotationsOf(element)
            .first
            .getField(field)
            ?.toStringValue() ??
        '';
  }

  static String getMethodType(MethodElement element) {
    if (element.metadata.first.toString().contains("@Get")) {
      return "get";
    }
    if (element.metadata.first.toString().contains("@Post")) {
      return "post";
    }
    if (element.metadata.first.toString().contains("@Delete")) {
      return "delete";
    }
    if (element.metadata.first.toString().contains("@Remove")) {
      return "remove";
    }
    return "_no_method";
  }

  static String cleanModelName(String name) => 
    name.toString().replaceAll("Future", "")
        .replaceAll("List", "")
        .replaceAll("<", "").replaceAll(">", "");

  static String getUrlByType(MethodElement element) {
    var type = getMethodType(element);
    if (type == "get") {
      return MedatadaExtractor.getFromElement(element, Get, 'path');
    }
    if (type == "post") {
      return MedatadaExtractor.getFromElement(element, Post, 'path');
    }
    if (type == "remove") {
      return MedatadaExtractor.getFromElement(element, Put, 'path');
    }
    if (type == "delete") {
      return MedatadaExtractor.getFromElement(element, Delete, 'path');
    }
    return "";
  }
}