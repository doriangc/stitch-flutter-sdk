import 'dart:convert';
import './content_types.dart' show ContentTypes;
import './headers.dart' show Headers;
import './stitch_request.dart' show StitchRequest, StitchRequestBuilder;

class StitchDocRequest extends StitchRequest {
  final dynamic document;

  StitchDocRequest(StitchRequest request, this.document) :
    super(
      request.method,
      request.path,
      request.headers,
      request.startedAt,
      request.body
    );
  
  StitchDocRequestBuilder builder() {
    return StitchDocRequestBuilder(this);
  }
}

class StitchDocRequestBuilder extends StitchRequestBuilder {
  dynamic document;

  StitchDocRequestBuilder([StitchDocRequest request]) :
    super(request) {

    if (request != null) {
      this.document = request.document;
    }
  }

  StitchDocRequestBuilder withDocument(dynamic document) {
    this.document = document;
    return this;
  }

  StitchDocRequest build() {
    if (this.document == null) {
      throw 'document must be set';
    }
    if (this.headers == null) {
      this.withHeaders({});
    }

    this.headers[Headers.CONTENT_TYPE] = ContentTypes.APPLICATION_JSON;
    print(document);
    this.withBody(json.encode(this.document));
    return new StitchDocRequest(super.build(), this.document);
  }
}
