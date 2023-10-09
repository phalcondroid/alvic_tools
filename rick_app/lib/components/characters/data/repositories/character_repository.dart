import 'package:alvic_tools_annotations/alvic_tools_annotations.dart';
import 'package:rick_app/components/characters/data/models/character.dart';

// Mandatory Libraries
import 'package:alvic_tools/alvic_tools.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

part 'character_repository.g.dart';

@RestRepository(
  path: "/character"
)
abstract class CharacterRepository {

  factory CharacterRepository() = _CharacterRepository;

  @Get(cached: true)
  Future<List<Character>> getAll(
    @Query()
    String page,
  );

  @Get()
  Future<Character> getById(
    @Path()
    String id
  );
}