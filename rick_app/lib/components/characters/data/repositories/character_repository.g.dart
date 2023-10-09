// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_repository.dart';

// **************************************************************************
// RestRepositoryGenerator
// **************************************************************************

class _CharacterRepository implements CharacterRepository {
  @override
  Future<List<Character>> getAll(String page) async {
    HttpAdapter adapter = GetIt.I<HttpAdapter>();
    List<Map<String, dynamic>> rawResponse = await adapter.get(
        '/character', HttpGetOptions(queries: {'page': page}));
    return rawResponse.map((item) => Character.fromJson(item)).toList();
  }

  @override
  Future<Character> getById(String id) async {
    HttpAdapter adapter = GetIt.I<HttpAdapter>();
    Map<String, dynamic> rawResponse =
        await adapter.getOne('/character/$id', HttpGetOptions());
    return Character.fromJson(rawResponse);
  }
}
