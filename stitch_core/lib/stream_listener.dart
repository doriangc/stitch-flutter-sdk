import 'stitch_exception.dart';

/// An interface defining a listener for the [Stream] type.
abstract class StreamListener<T> {
  /// Called whenever the stream with which this listener is registered receives
  /// an object from the remote source.
  void onNext(T data);

  /// Called whenever the stream with which this listener is registered produces
  /// an error.
  void onError(StitchException error);
}
