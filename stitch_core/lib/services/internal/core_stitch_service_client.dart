
import '../../internal/common/codec.dart';
import '../../stream.dart' show Stream; 
import './stitch_service_binder.dart' show StitchServiceBinder;

abstract class CoreStitchServiceClient extends StitchServiceBinder {
  Future<T> callFunction<T>(
    String name,
    List<dynamic> args,
    [Decoder<T> decoder]
  );

  Future<Stream<T>> streamFunction<T>(
    String name,
    List<dynamic> args,
    [Decoder<T> decoder]
  );

  /// Bind a given service to this service client.
  bind(StitchServiceBinder binder);
}