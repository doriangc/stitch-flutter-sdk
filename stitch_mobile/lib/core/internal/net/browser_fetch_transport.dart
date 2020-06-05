import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:stitch_core/stitch_core.dart' show BasicRequest, EventStream, Response, Transport;
import 'package:stitch_core/stitch_request_exception.dart';

class BrowserFetchTransport implements Transport {
  Future<Response> roundTrip(BasicRequest request) async {
    http.Request httpRequest = http.Request(
      request.method,
      Uri.parse(request.url)
    );

    // httpRequest.timeout = 5;

    httpRequest.body = request.body ?? '';
      
    request.headers.forEach((key, value) { // set all of the headers
      httpRequest.headers[key] = value;
    });

    // httpRequest.

    http.StreamedResponse responseStream = await httpRequest.send().timeout(Duration(seconds: 10), onTimeout: (){
      throw StitchRequestException(StitchRequestExceptionCode.TRANSPORT_ERROR);
    });

    http.Response response = await http.Response.fromStream(responseStream).timeout(Duration(seconds: 10), onTimeout: (){
      throw StitchRequestException(StitchRequestExceptionCode.TRANSPORT_ERROR);
    });
    
    return Response(response.headers, response.statusCode, response.body);
  }

  Future<EventStream> stream(BasicRequest request, [open = true, Future<EventStream> Function() retryRequest]) {
    throw 'Streaming is not currently supported in the Dart Stitch SDK.';
  }
}
