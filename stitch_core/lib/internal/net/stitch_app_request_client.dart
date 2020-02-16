import 'dart:convert';

import './api_app_metadata.dart' show ApiAppMetadata;
import './base_stitch_request_client.dart' show BaseStitchRequestClient;
import './event_stream.dart' show EventStream;
import './response.dart' show Response;
import 'stitch_app_routes.dart' show StitchAppRoutes;
import './stitch_request.dart' show StitchRequest, StitchRequestBuilder;
import './transport.dart' show Transport;


class StitchAppRequestClient extends BaseStitchRequestClient {
  final String _clientAppId;
  final StitchAppRoutes _routes;

  ApiAppMetadata _appMetadata;

  StitchAppRequestClient(String clientAppId, String baseUrl, Transport transport) :
    _clientAppId = clientAppId,
    _routes = StitchAppRoutes(clientAppId),
    super(baseUrl, transport);

  Future<Response> doRequest(StitchRequest stitchReq) async {
    ApiAppMetadata metadata = await _initAppMetadata();
    return await super.doRequestToURL(stitchReq, metadata.hostname);
  }

  Future<EventStream> doStreamRequest(StitchRequest stitchReq, {Future<EventStream> Function() retryRequest, open = true}) async {
    ApiAppMetadata metadata = await _initAppMetadata();
    return await super.doStreamRequestToURL(stitchReq, metadata.hostname, open: open, retryRequest: retryRequest);
  }

  Future<String> getBaseURL() async {
    ApiAppMetadata metadata = await _initAppMetadata();
    return metadata.hostname;
  }

  Future<ApiAppMetadata> _initAppMetadata() async {
    if (_appMetadata != null) {
      return _appMetadata;
    }

    StitchRequest request = StitchRequestBuilder()
      .withMethod('GET')
      .withPath(_routes.appMetadataRoute)
      .build();

    Response resp = await super.doRequestToURL(request, this.baseUrl);
    _appMetadata = ApiAppMetadata.fromJSON(json.decode(resp.body));
    return _appMetadata;
  }
}

