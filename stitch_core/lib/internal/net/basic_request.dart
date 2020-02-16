enum Method {
  GET,
  POST,
  PUT,
  DELETE,
  HEAD,
  OPTIONS,
  TRACE,
  PATCH
}

class BasicRequest {
  final String method;
  final String url;
  final Map<String, String> headers;
  final String body;

  BasicRequest(
    this.method,
    this.url,
    this.headers,
    [this.body]
  );
}

class BasicRequestBuilder {
  String method;
  String url;
  Map<String, String> headers;
  String body;

  BasicRequestBuilder([BasicRequest request]) {
    if (request == null) {
      return;
    }

    this.method = request.method;
    this.url = request.url;
    this.headers = request.headers;
    this.body = request.body;
  }

  BasicRequestBuilder withMethod(String method) {
    this.method = method;
    return this;
  }

  BasicRequestBuilder withUrl(String url) {
    this.url = url;
    return this;
  }

  BasicRequestBuilder withHeaders(Map<String, String> headers) {
    this.headers = headers;
    return this;
  }

  BasicRequestBuilder withBody([String body]) {
    this.body = body;
    return this;
  }

  BasicRequest build() {
    if (this.method == null) {
      throw 'must set method';
    }
    if (this.url == null) {
      throw 'must set non-empty url';
    }
    return new BasicRequest(
      this.method,
      this.url,
      this.headers == null ? {} : this.headers,
      this.body
    );
  }
}
