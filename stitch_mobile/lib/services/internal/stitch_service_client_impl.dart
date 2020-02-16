import 'package:stitch_core/stitch_core.dart' show
  CoreStitchServiceClient,
  Decoder,
  Stream;

import '../stitch_service_client.dart' show StitchServiceClient;

class StitchServiceClientImpl implements StitchServiceClient {
  CoreStitchServiceClient proxy;

  StitchServiceClientImpl(this.proxy);

  Future<T> callFunction<T>(String name, List<dynamic> args,
      [Decoder<T> codec]) {
    return this.proxy.callFunction(name, args, codec);
  }

  Future<Stream<T>> streamFunction<T>(String name, List<dynamic> args,
      [Decoder<T> codec]) {
    return this.proxy.streamFunction(name, args, codec);
  }
}
