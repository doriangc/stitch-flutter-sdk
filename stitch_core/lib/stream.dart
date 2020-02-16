import './internal/common/codec.dart' show Decoder;
import './internal/net/event.dart' show Event;
import './internal/net/event_listener.dart' show EventListener;
import './internal/net/event_stream.dart' show EventStream;
import './internal/net/stitch_event.dart' show StitchEvent;
import './stream_listener.dart' show StreamListener;
import './stitch_exception.dart';

class _CustomListener extends EventListener {
  // @override
  final Function(Event event) onEventCall;

  _CustomListener(this.onEventCall);

  @override
  void onEvent(Event event) {
    onEventCall(event);
  }
}

/// A Stream represents an ongoing stream of objects from a remote source, such
/// as a MongoDB change stream as opened by a call to
/// [RemoteMongoCollection.watch].
class Stream<T> {
  EventStream eventStream;
  Decoder<T> decoder;

  // List<StreamListener<T>, EventListener> listeners;
  List<dynamic> listeners;

  Stream(this.eventStream, this.decoder) {
    this.listeners = [];
  }

  /// Returns the next object received from the stream.
  ///
  /// This will not return any objects that were already received from
  /// the remote source but with no listener to process them. The object
  /// must be received from the remote source after this method is called.
  ///
  /// @return a Promise containing the next object received from the stream. If
  ///         there is no object yet available on the stream, the Promise will
  ///         not resolve until there is.
  Future<T> next() async {
    var event = await this.eventStream.nextEvent();
    StitchEvent se = StitchEvent.fromEvent(event, this.decoder);
    if (se.eventName == StitchEvent.ERROR_EVENT_NAME) {
      throw se.error;
    }
    if (se.eventName == Event.MESSAGE_EVENT) {
      return se.data;
    }
    return this.next();
  }

  /// Sets up a callback that will be called when objects are received
  /// from the stream. This callback cannot be cancelled.
  void onNext(void callback(T data)) {
    _CustomListener wrapper = _CustomListener((Event event) {
      StitchEvent se = StitchEvent.fromEvent(event, this.decoder);
      if (se.eventName != Event.MESSAGE_EVENT) {
        return;
      }
      callback(se.data);
    });

    this.eventStream.addListener(wrapper);
  }

  /// Sets up a callback that will be called when this stream produces an error.
  /// This callback cannot be cancelled.
  void onError(void callback(StitchException error)) {
    _CustomListener wrapper = _CustomListener((e) {
      StitchEvent se = StitchEvent.fromEvent(e, this.decoder);
      if (se.eventName == StitchEvent.ERROR_EVENT_NAME) {
        callback(se.error);
      }
    });

    this.eventStream.addListener(wrapper);
  }

  /// Registers a [StreamListener] object whose onNext method will be called
  /// whenever this stream receives a new object, and whose onError method
  /// will be called whenever this stream produces an error. This listener can
  /// later be removed by [removeListener].
  void addListener(StreamListener<T> listener) {
    _CustomListener wrapper = _CustomListener((e) {
      StitchEvent se = StitchEvent.fromEvent(e, this.decoder);
      if (se.eventName == StitchEvent.ERROR_EVENT_NAME) {
        if (listener.onError != null) {
          listener.onError(se.error);
        }
      } else {
        if (listener.onNext != null) {
          listener.onNext(se.data);
        }
      }
    });
    this.listeners.add([listener, wrapper]);
    this.eventStream.addListener(wrapper);
  }

  /// Unregisters a listener object previously added to this stream by
  /// [addListener].
  void removeListener(StreamListener<T> listener) {
    int index = -1;
    for (int i = 0; i < this.listeners.length; i++) {
      if (this.listeners[i][0] == listener) {
        index = i;
        break;
      }
    }
    if (index == -1) {
      return;
    }
    var wrapper = this.listeners[index][1];
    this.listeners.sublist(index, 1);
    this.eventStream.removeListener(wrapper);
  }

  /// Whether or not the underlying event stream is still open.
  bool isOpen() {
    return this.eventStream.isOpen();
  }

  /// Closes the underlying stream, which will prevent the stream from receiving
  /// any more events.
  void close() {
    this.eventStream.close();
  }
}
