
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:alvic_tools/alvic_tools.dart';
import 'package:alvic_tools/src/core/config/alvic_tools_config.dart';

class AlvicToolsInitializer {
  
  final AlvicToolsConfig config;

  const AlvicToolsInitializer({
    required this.config
  });

  void init() {
    print("initializing....");
    GetIt.instance.registerSingleton<Dio>(Dio());
    GetIt.instance.registerSingleton<AlvicToolsConfig>(config);
    config.initConfig(GetIt.I.get<Dio>());
    GetIt.instance.registerSingleton<HttpAdapter>(HttpAdapter());
  }
}