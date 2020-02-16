import './event.dart';
import './event_listener.dart';

abstract class EventStream {
  Future<Event> nextEvent();
  void addListener(EventListener listener);
  void removeListener(EventListener listener);
  bool isOpen();
  void open();
  void close();
}