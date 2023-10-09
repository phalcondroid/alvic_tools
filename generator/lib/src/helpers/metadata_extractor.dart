import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

class MedatadaExtractor {
  static dynamic getFromElement(Element element, Type type, String field) {
    return TypeChecker.fromRuntime(type)
            .annotationsOf(element)
            .first
            .getField('path')
            ?.toStringValue() ??
        '';
  }
}