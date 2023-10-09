import 'package:alvic_tools/src/generators/rest_repository_generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder restRepositoryGenerator(BuilderOptions options) =>
    SharedPartBuilder([RestRepositoryGenerator()], 'rest_repository_generator');