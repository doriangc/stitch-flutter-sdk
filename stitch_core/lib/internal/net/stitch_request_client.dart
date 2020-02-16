import './transport.dart';
import './event_stream.dart';
import './stitch_request.dart';
import './base_stitch_request_client.dart';
import './response.dart';

class StitchRequestClient extends BaseStitchRequestClient {
  StitchRequestClient(String baseUrl, Transport transport) : super(baseUrl, transport);

  Future<Response> doRequest(StitchRequest stitchReq) {
    return super.doRequestToURL(stitchReq, baseUrl);
  }

  Future<EventStream> doStreamRequest(StitchRequest stitchReq, {open = true, Future<EventStream> retryRequest() }) {
    return super.doStreamRequestToURL(stitchReq, this.baseUrl, open: open, retryRequest: retryRequest);
  }

  String getBaseURL() {
    return this.baseUrl;
  }
}
