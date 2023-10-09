class Get {
  final String path;
  final bool cached;
  final List<String>? headers;

  const Get({
    this.path = "",
    this.cached = false,
    this.headers,
  });  
}