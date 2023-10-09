class AlvicContainer {
  final Map<String, dynamic>? content;

  const AlvicContainer({ this.content });
  
  dynamic getContent(String key) => content?[key];
}