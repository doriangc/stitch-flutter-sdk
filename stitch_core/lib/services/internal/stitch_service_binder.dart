import './rebind_event.dart' show RebindEvent;

abstract class StitchServiceBinder {
    /// Notify the binder that a rebind event has occurred. E.g. a change in the
    /// active user.
    onRebindEvent(RebindEvent rebindEvent);
}
