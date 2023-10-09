import 'package:get_it/get_it.dart';
import 'package:rick_app/components/characters/data/repositories/character_repository.dart';
import 'package:rick_app/components/common/data/character_dto.dart';

class GetCharacters {
  const GetCharacters();
  
  Future<List<CharacterDto>> call() async {
    var repo = GetIt.instance<CharacterRepository>();
    List<CharacterDto> characters = await repo.getAll("1");
    return characters;
  }
}