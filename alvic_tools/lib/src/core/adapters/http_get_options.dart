import 'package:alvic_tools/src/core/adapters/data_options.dart';

class HttpGetOptions extends DataOptions {
  final String paths;
  final Map<String, dynamic> queries;
  final String sourceKey;

  const HttpGetOptions({
    this.paths = "",
    this.queries = const {},
    this.sourceKey = ""
  });
}