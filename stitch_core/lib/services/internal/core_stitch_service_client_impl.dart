import 'dart:convert';
import '../../auth/internal/auth_event.dart' show AuthEventKind;
import '../../auth/internal/stitch_auth_request_client.dart' show StitchAuthRequestClient;
import '../../internal/common/base64.dart' show customBase64Encode;
import '../../internal/common/codec.dart' show Decoder;
import '../../internal/net/stitch_auth_doc_request.dart' show StitchAuthDocRequest, StitchAuthDocRequestBuilder;
import '../../internal/net/stitch_auth_request.dart' show StitchAuthRequest, StitchAuthRequestBuilder;
import '../../stream.dart' show Stream;
import './auth_rebind_event.dart' show AuthRebindEvent;
import './core_stitch_service_client.dart' show CoreStitchServiceClient;
import './rebind_event.dart' show RebindEvent, RebindEventType;
import './stitch_service_binder.dart' show StitchServiceBinder;
import './stitch_service_routes.dart' show StitchServiceRoutes;

class CoreStitchServiceClientImpl implements CoreStitchServiceClient {

  StitchAuthRequestClient requestClient;
  StitchServiceRoutes serviceRoutes;
  String serviceName;

  List<StitchServiceBinder> serviceBinders = [];
  List<Stream<dynamic>> allocatedStreams = [];

  String serviceField = 'service';
  String argumentsField = 'arguments';

  CoreStitchServiceClientImpl(
    this.requestClient,
    StitchServiceRoutes routes,
    [String name]
  ) : this.serviceRoutes = routes,
    this.serviceName = name;

  Future<T> callFunction<T>(
    String name,
    List<dynamic> args,
    [Decoder<T> decoder]
  ) async {
    return this.requestClient.doAuthenticatedRequestWithDecoder(
      this.getCallServiceFunctionRequest(name, args),
      decoder
    );
  }

  Future<Stream<T>> streamFunction<T>(
    String name,
    List<dynamic> args,
    [Decoder<T> decoder]
  ) async {
    Stream<T> newStream = await this.requestClient.openAuthenticatedStreamWithDecoder(this.getStreamServiceFunctionRequest(name, args), decoder);
    this.allocatedStreams.add(newStream);
    return newStream;
  }

  bind(StitchServiceBinder binder) {
    this.serviceBinders.add(binder);
  }

  onRebindEvent(RebindEvent rebindEvent) {
    switch (rebindEvent.type) {
      case RebindEventType.AUTH_EVENT:
        AuthRebindEvent authRebindEvent = rebindEvent as AuthRebindEvent<dynamic>;
        if (authRebindEvent.event.kind == AuthEventKind.ActiveUserChanged) {
          _closeAllocatedStreams();
        }
        break;
      default:
        break;
    }

    this.serviceBinders.forEach((binder) {
      binder.onRebindEvent(rebindEvent);
    });
  }

  StitchAuthRequest getStreamServiceFunctionRequest(
    String name,
    List<dynamic> args
  ) {
    Map<String, dynamic> body = { 'name': name };
    if (this.serviceName != null) {
      body[this.serviceField] = this.serviceName;
    }
    body[this.argumentsField] = args;

    StitchAuthRequestBuilder reqBuilder = StitchAuthRequestBuilder();
    reqBuilder
      .withMethod('GET')
      .withPath(this.serviceRoutes.functionCallRoute +
        '?stitch_request=${Uri.encodeFull(customBase64Encode(json.encode(body)))}');
    return reqBuilder.build();
  }

  StitchAuthRequest getCallServiceFunctionRequest(
    String name,
    List<dynamic> args
  ) {
    Map<String, dynamic> body = { 'name': name };
    
    if (this.serviceName != null) {
      body[this.serviceField] = this.serviceName;
    }

    body[this.argumentsField] = args;

    StitchAuthDocRequestBuilder reqBuilder = StitchAuthDocRequestBuilder();
    reqBuilder
      .withMethod('POST')
      .withPath(this.serviceRoutes.functionCallRoute);
    reqBuilder.withDocument(body);
    return reqBuilder.build();
  }

  _closeAllocatedStreams() {
    this.allocatedStreams.forEach( (stream) {
      if (stream.isOpen()) {
        stream.close();
      }
    });
    this.allocatedStreams = [];
  }
}
