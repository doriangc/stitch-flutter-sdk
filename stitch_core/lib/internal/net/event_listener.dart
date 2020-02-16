import './event.dart';

abstract class EventListener {
  void onEvent(Event event);
}