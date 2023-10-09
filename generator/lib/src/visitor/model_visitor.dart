import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:generator/src/helpers/metadata_extractor.dart';

class ModelVisitor extends SimpleElementVisitor<void> {

  late String className;
  final fields = <String, dynamic>{};
  final Map<String, dynamic> metaData = {};

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
    // print("methods: ${MedatadaExtractor.getFromElement(element, Get, "path")}");
  }
}
