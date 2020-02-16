import './stitch_request.dart';

class StitchAuthRequest extends StitchRequest {
  final bool useRefreshToken;
  final bool shouldRefreshOnFailure;

  StitchAuthRequest(StitchRequest request,
      {this.useRefreshToken = false, this.shouldRefreshOnFailure = true})
      : super(request.method, request.path, request.headers, request.startedAt,
            request.body);

  StitchAuthRequestBuilder builder() {
    return StitchAuthRequestBuilder(this);
  }
}

class StitchAuthRequestBuilder extends StitchRequestBuilder {
  bool useRefreshToken;
  bool shouldRefreshOnFailure;

  StitchAuthRequestBuilder([StitchAuthRequest request]) : super(request);

  StitchAuthRequestBuilder withAccessToken() {
    this.useRefreshToken = false;
    return this;
  }

  StitchAuthRequestBuilder withRefreshToken() {
    this.useRefreshToken = true;
    return this;
  }

  StitchAuthRequestBuilder withShouldRefreshOnFailure(
      bool shouldRefreshOnFailure) {
    this.shouldRefreshOnFailure = shouldRefreshOnFailure;
    return this;
  }

  StitchAuthRequest build() {
    if (useRefreshToken != null && useRefreshToken) {
      this.shouldRefreshOnFailure = false;
    }

    return StitchAuthRequest(super.build(),
        useRefreshToken: this.useRefreshToken,
        shouldRefreshOnFailure: this.shouldRefreshOnFailure);
  }
}
