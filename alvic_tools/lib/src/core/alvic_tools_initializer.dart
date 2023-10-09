
import 'package:alvic_tools/src/core/adapters/local_storage_adapter.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:alvic_tools/alvic_tools.dart';
import 'package:alvic_tools/src/core/config/alvic_tools_config.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AlvicToolsInitializer {
  
  final AlvicToolsConfig config;

  const AlvicToolsInitializer({
    required this.config,
  });

  void init() async {
    print("alvic tools initializing....");
    await initLocalStorage();
    GetIt.instance.registerSingleton<Dio>(Dio());
    GetIt.instance.registerSingleton<AlvicToolsConfig>(config);
    GetIt.instance.registerSingleton<AlvicContainer>(AlvicContainer(
      content: {}
    ));
    config.initConfig(GetIt.I.get<Dio>());
    GetIt.instance.registerSingleton<HttpAdapter>(HttpAdapter());
    GetIt.instance.registerSingleton<LocalStorageAdapter>(LocalStorageAdapter());
    if (config.injector?.inject != null) {
      config.injector?.inject!(GetIt.I);
    }
  }

  initLocalStorage() async {
    Hive.initFlutter();
  }
}