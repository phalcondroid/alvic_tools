
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
    print("initializing....");

   // final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.initFlutter();

    var box = Hive.box('testBox');
    box.put('name', 'David');

    var name = box.get('name');

    print('hiveeee Name: $name');
    
    GetIt.instance.registerSingleton<Dio>(Dio());
    GetIt.instance.registerSingleton<AlvicToolsConfig>(config);
    config.initConfig(GetIt.I.get<Dio>());
    GetIt.instance.registerSingleton<HttpAdapter>(HttpAdapter());
    if (config.injector?.inject != null) {
      config.injector?.inject!(GetIt.I);
    }
  }
}