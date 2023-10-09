class AlvicException implements Exception {
  final String message;
  const AlvicException([this.message = ""]);

  @override
  String toString() => " [AlvicException]: $message";
}