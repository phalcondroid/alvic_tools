import 'package:build/build.dart';
import 'package:generator/src/generators/rest_repository_generator.dart';
import 'package:source_gen/source_gen.dart';

// import 'src/examples/extension_generator.dart';
// import 'src/examples/subclass_generator.dart';

// Builder generateLocalRepository(BuilderOptions options) =>
//     SharedPartBuilder([ExtensionGenerator()], 'extension_generator');
    
Builder restGenerator(BuilderOptions options) =>
    SharedPartBuilder([RestRepositoryGenerator()], 'rest_generator');