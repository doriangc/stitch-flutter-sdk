import 'dart:async';

import '../../stitch_exception.dart' show StitchException;
import './event.dart' show Event;
import './event_listener.dart' show EventListener;
import './event_stream.dart' show EventStream;
import './stitch_event.dart' show StitchEvent;

class _CustomListener extends EventListener {
  // @override
  final Function(Event event) onEventCall;

  _CustomListener(this.onEventCall);

  @override
  void onEvent(Event event) {
    onEventCall(event);
  }
}

abstract class BaseEventStream<T extends BaseEventStream<T>> implements EventStream {
  static const int RETRY_TIMEOUT_MILLIS = 5000;
  bool closed;
  List<Event> events;
  List<EventListener> listeners;
  String lastErr;

  Future<T> Function() reconnecter;

  BaseEventStream([this.reconnecter]) :
    this.closed = false,
    this.events = [],
    this.listeners = [],
    this.lastErr = null;

  bool isOpen() {
    return !this.closed;
  }

  void open();

  void addListener(EventListener listener) {
    if (this.closed) {
      listener.onEvent(new Event(StitchEvent.ERROR_EVENT_NAME, "stream closed"));
      // Future.delayed(Duration(milliseconds: 0), () => {})
      return;
    }
    if (this.lastErr != null) {
      listener.onEvent(new Event(StitchEvent.ERROR_EVENT_NAME, this.lastErr));
      return;
    }
    this.listeners.add(listener);
    this.poll();
  }

  void removeListener(EventListener listener) {
    int index = this.listeners.indexOf(listener);
    if (index == -1) {
      return;
    }
    this.listeners.removeRange(index, index+1);
  }

  Future<Event> nextEvent() {
    if (this.closed) {
      // return Promise.reject(new Event(StitchEvent.ERROR_EVENT_NAME, "stream closed"));
      throw StitchException('stream closed');
    }
    if (this.lastErr != null) {
      // return Promise.reject(new Event(StitchEvent.ERROR_EVENT_NAME, this.lastErr));
      throw StitchException(lastErr);
    }
    var completer = Completer();
  
    listenOnce(_CustomListener(
      (e) { 
        completer.complete(e);
      }
    ));

    return completer.future;
  }

  void close() {
    if (this.closed) {
      return;
    }
    this.closed = true;
    this.afterClose();
  }

  void afterClose();

  void onReconnect(T next);

  void reconnect(Error error) async {
    if (this.reconnecter == null) {
      if (!this.closed) {
        this.closed = true;
        this.events.add(Event(StitchEvent.ERROR_EVENT_NAME, 'stream closed: $error'));
        this.poll();
      }
      return;
    }
    try {
      T next = await this.reconnecter();
      this.onReconnect(next);
    } catch(e) {
      // if (!(e is StitchError) || !(e is StitchRequestError)) {
      //   this.closed = true;
      //   this.events.push(new Event(StitchEvent.ERROR_EVENT_NAME, `stream closed: ${error}`));
      //   this.poll();
      //   return; 
      // }
      Future.delayed(Duration(milliseconds: BaseEventStream.RETRY_TIMEOUT_MILLIS), () => this.reconnect(e));
    }
  }

  void poll() {
    while (this.events.length != 0) {
      Event event = this.events.removeLast();  
      for (EventListener listener in this.listeners) {
        if (listener.onEvent != null) {
          listener.onEvent(event);        
        }
      }
    }
  }

  void listenOnce(EventListener listener) {
    if (this.closed) {
      listener.onEvent(new Event(StitchEvent.ERROR_EVENT_NAME, "stream closed"));
      return;
    }
    if (this.lastErr != null) {
      listener.onEvent(new Event(StitchEvent.ERROR_EVENT_NAME, this.lastErr));
      return;
    }

    _CustomListener wrapper;

    listenerAction(Event e) {
      this.removeListener(wrapper);
      listener.onEvent(e);
    }

    wrapper = _CustomListener(
      listenerAction
    );

    this.addListener(wrapper);
  }
}
