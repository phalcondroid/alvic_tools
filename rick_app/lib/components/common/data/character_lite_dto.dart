abstract interface class CharacterLiteDto {
  final int id;
  final String name;
  final String status;

  CharacterLiteDto({
    required this.id,
    required this.name,
    required this.status,
  });
}