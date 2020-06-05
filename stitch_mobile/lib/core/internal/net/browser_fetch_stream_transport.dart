import 'dart:io';

import 'package:stitch_core/stitch_core.dart' show
  BasicRequest,
  ContentTypes,
  EventStream,
  handleRequestError,
  Headers,
  Response,
  Transport;

// import {fetch as fetch} from 'whatwg-fetch'
import './browser_fetch_transport.dart' show BrowserFetchTransport;
import 'browser_event_stream.dart';

import 'package:http/http.dart' as http;

class BrowserFetchStreamTransport extends BrowserFetchTransport {

  Future<EventStream> stream(BasicRequest request, [open = true, Future<EventStream> Function() retryRequest]) async {
    // const reqHeaders = { ...request.headers };
    // reqHeaders[Headers.ACCEPT] = ContentTypes.TEXT_EVENT_STREAM;
    // reqHeaders[Headers.CONTENT_TYPE] = ContentTypes.TEXT_EVENT_STREAM;

    // // Verify we can start a request with current params and potentially
    // // Force ourselves to refresh a token.
    // return fetch(request.url + "&stitch_validate=true", { // Do a test request
    //   body: request.body,
    //   headers: reqHeaders,
    //   method: request.method,
    //   mode: 'cors'
    // }).then(response => {
    //   const respHeaders: { [key: string]: string } = {};
    //   response.headers.forEach((value, key) => {
    //     respHeaders[key] = value;
    //   });
    //   if (response.status < 200 || response.status >= 300) {
    //     return response.text()
    //     .then(body => handleRequestError(new Response(respHeaders, response.status, body)));
    //   }


    var r = await super.roundTrip(request); // test request
    print(r.body);
    print('test request done...');

    print('opening socket...');
    http.Request httpRequest = http.Request(
      request.method,
      Uri.parse(request.url)
    );

    // httpRequest.timeout = 5;

    // httpRequest.body = request.body ?? '';
    httpRequest.persistentConnection = true;
    // httpRequest.
      
    // request.headers.forEach((key, value) { // set all of the headers
      // httpRequest.headers[key] = value;
    // });

    // httpRequest.

    // HttpClient().openUrl(method, url);
    // HttpClient().open(method, host, port, path)

    http.StreamedResponse responseStream = await httpRequest.send();

    // var socket = await Socket.connect(request.url, 80);
    // var socket = await WebSocket.connect(request.url.replaceAll('https', 'http'));
    

    // await Future.delayed(Duration(seconds: 60), () {
    //   print('time\'s up!');
    //   socket.close();
    // });

    // var httpRequest = http.StreamedRequest(request.method, Uri.parse(request.url));
    // print('init is finished');

    // var sendStream = await httpRequest.send();
    // print('sendstream done.');
      
    // request.headers.forEach((key, value) { // set all of the headers
    //   httpRequest.headers[key] = value;
    // });

    return BrowserEventStream(
      responseStream,
      // (stream) {},
      // (error) {},
      retryRequest != null ? 
        () => retryRequest().then((es) => es as BrowserEventStream)
        : null
    );
  }
}
