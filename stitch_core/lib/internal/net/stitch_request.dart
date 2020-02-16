class StitchRequest {
  final String method;
  final String path;
  final Map<String, String> headers;
  final double startedAt;
  final String body;

  StitchRequest(
      this.method, this.path, this.headers, this.startedAt, this.body);

  StitchRequestBuilder builder() {
    return StitchRequestBuilder(this);
  }
}

class StitchRequestBuilder {
  String method;
  String path;
  Map<String, String> headers;
  String body;
  double startedAt;

  StitchRequestBuilder([StitchRequest request]) {
    if (request != null) {
      this.method = request.method;
      this.path = request.path;
      this.headers = request.headers;
      this.body = request.body;
      this.startedAt = request.startedAt;
    }
  }

  StitchRequestBuilder withMethod(String method) {
    this.method = method;
    return this;
  }

  StitchRequestBuilder withPath(String path) {
    this.path = path;
    return this;
  }

  StitchRequestBuilder withHeaders(Map<String, String> headers) {
    this.headers = headers;
    return this;
  }

  StitchRequestBuilder withBody(String body) {
    this.body = body;
    return this;
  }

  StitchRequest build() {
    if (this.method == null) {
      throw 'must set method';
    }
    if (this.path == null) {
      throw 'must set non-empty path';
    }
    if (this.startedAt == null) {
      this.startedAt = DateTime.now().millisecondsSinceEpoch / 1000;
    }
    return new StitchRequest(this.method, this.path,
        this.headers == null ? {} : this.headers, this.startedAt, this.body);
  }
}
