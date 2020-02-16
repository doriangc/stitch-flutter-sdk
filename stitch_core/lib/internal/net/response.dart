class Response {
  Map<String, String> headers = {};
  final int statusCode;
  final String body;

  Response(
    Map<String, String> respHeaders,
    this.statusCode,
    this.body
  ) {
    // Preprocess headers
    respHeaders.keys.forEach((String key) {
      headers[key.toLowerCase()] = respHeaders[key];
    });
  }
}