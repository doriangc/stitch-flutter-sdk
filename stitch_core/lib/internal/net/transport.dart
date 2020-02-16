import './basic_request.dart';
import 'response.dart';
import 'event_stream.dart';

abstract class Transport {
  Future<Response> roundTrip(BasicRequest request);
  Future<EventStream> stream(BasicRequest request, {bool open, Future<EventStream> retryRequest()});
}
