import '../../stitch_service_exception.dart';
import 'stitch_request.dart';
import 'response.dart';
import 'transport.dart';
import 'event_stream.dart';
import 'basic_request.dart';
import '../common/stitch_error_utils.dart';
import '../../stitch_request_exception.dart';
import '../../stitch_exception.dart';

Response inspectResponse(StitchRequest request, String url, Response response) {
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return response;
  }

  return handleRequestError(response);
}

abstract class BaseStitchRequestClient {
  String baseUrl;
  Transport transport;

  BaseStitchRequestClient(this.baseUrl, this.transport);

  Future<Response> doRequestToURL(StitchRequest stitchReq, String url) async {
    // print('============== Request =====================');
    // print('url: $url');
    // print('headers: ${stitchReq.headers}');
    // print('body: ${stitchReq.body}');
    // print('path: ${stitchReq.path}');
    // print('method: ${stitchReq.method}');
    // print('============================================');

    try {
      Response response = await transport.roundTrip(_buildRequest(stitchReq, url));
      
      // print('============== Response =====================');
      // print('body: ${response.body}');
      // print('headers: ${response.headers}');
      // print('============================================');

      return inspectResponse(stitchReq, url, response);
    } catch (e) {
      if (e is String) {
        throw StitchTransportException(e);
      }
      
      throw e;
    }
  }

  Future<EventStream> doStreamRequestToURL(StitchRequest stitchReq, String url, {open = true, Future<EventStream> retryRequest()}) {
    try {
      return transport.stream(_buildRequest(stitchReq, url), open: open, retryRequest: retryRequest);
    } catch(e) {
      throw StitchTransportException(e);
    }
  }

  BasicRequest _buildRequest(StitchRequest stitchReq, String url) {
    return new BasicRequestBuilder()
      .withMethod(stitchReq.method)
      .withUrl('$url${stitchReq.path}')
      .withHeaders(stitchReq.headers)
      .withBody(stitchReq.body)
      .build();
  }
}