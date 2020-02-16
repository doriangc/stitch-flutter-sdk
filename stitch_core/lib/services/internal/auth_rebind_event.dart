import '../../stitch_core.dart' show AuthEvent, CoreStitchUser;
import './rebind_event.dart' show RebindEvent, RebindEventType;

class AuthRebindEvent<TStitchUser extends CoreStitchUser> extends RebindEvent {
  RebindEventType type = RebindEventType.AUTH_EVENT;

  AuthEvent<TStitchUser> event;

  AuthRebindEvent(AuthEvent<TStitchUser> event) :
    super() {
    this.event = event;
  }
}
