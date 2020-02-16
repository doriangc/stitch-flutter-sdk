
class Event {
  static const String MESSAGE_EVENT = "message";

  final String eventName;
  final String data;

  Event(
    this.eventName,
    this.data
  );
}