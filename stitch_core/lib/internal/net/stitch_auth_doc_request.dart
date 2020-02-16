import 'dart:convert';

import './headers.dart' show Headers;
import './content_types.dart' show ContentTypes;
import './stitch_auth_request.dart' show StitchAuthRequest, StitchAuthRequestBuilder;

class StitchAuthDocRequest extends StitchAuthRequest {
  final dynamic document;

  StitchAuthDocRequest(
    request,
    this.document
  ) : super(request, useRefreshToken: request.useRefreshToken ?? false, shouldRefreshOnFailure: request.shouldRefreshOnFailure ?? true);

  StitchAuthDocRequestBuilder builder() {
    return StitchAuthDocRequestBuilder(this);
  }
}

 class StitchAuthDocRequestBuilder extends StitchAuthRequestBuilder {
  dynamic document;

  StitchAuthDocRequestBuilder([StitchAuthDocRequest request]) :
    super(request) {

    if (request != null) {
      this.document = request.document;
      this.useRefreshToken = request.useRefreshToken;
    }
  }

  StitchAuthDocRequestBuilder withDocument(dynamic document) {
    this.document = document;
    return this;
  }

  StitchAuthDocRequestBuilder withAccessToken() {
    useRefreshToken = false;
    return this;
  }

  StitchAuthDocRequest build() {
    if (this.document == null) {
      throw 'document must be set';
    }

    if (this.headers == null) {
      this.withHeaders({});
    }

    this.headers[Headers.CONTENT_TYPE] = ContentTypes.APPLICATION_JSON;

    this.withBody(json.encode(this.document));
    return new StitchAuthDocRequest(super.build(), this.document);
  }
}
