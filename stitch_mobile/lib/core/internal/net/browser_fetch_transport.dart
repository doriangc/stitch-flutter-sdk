import 'package:http/http.dart' as http;

import 'package:stitch_core/stitch_core.dart' show BasicRequest, EventStream, Response, Transport;

class BrowserFetchTransport implements Transport {
  Future<Response> roundTrip(BasicRequest request) async {
    http.Request httpRequest = http.Request(
      request.method,
      Uri.parse(request.url)
    );

    httpRequest.body = request.body ?? '';
      
    request.headers.forEach((key, value) { // set all of the headers
      httpRequest.headers[key] = value;
    });

    http.Response response = await http.Response.fromStream(await httpRequest.send());
    
    return Response(response.headers, response.statusCode, response.body);
  }

  Future<EventStream> stream(BasicRequest request, {bool open = true, Future<EventStream> retryRequest()}) {
    throw 'Streaming is not currently supported in the Dart Stitch SDK.';
  }
}
