class AlvicContainer {
  final Map<String, dynamic>? content;

  const AlvicContainer({ this.content = const {} });
  
  dynamic getContent(String key) => content?[key];

  setContent(String key, dynamic val) {
    content?[key] = val;
  }
}