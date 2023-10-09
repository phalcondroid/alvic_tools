class ProjectException implements Exception {
  final String message;
  const ProjectException([this.message = ""]);

  @override
  String toString() => "ProjectException: $message";
}