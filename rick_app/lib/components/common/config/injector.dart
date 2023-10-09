import 'package:get_it/get_it.dart';
import 'package:rick_app/components/characters/data/repositories/character_repository.dart';

class Injector {
  void inject() {
    GetIt.instance.registerSingleton<CharacterRepository>(CharacterRepository());
  }
}