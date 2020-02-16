enum RebindEventType {
    AUTH_EVENT
}

abstract class RebindEvent {
    RebindEventType type;
}