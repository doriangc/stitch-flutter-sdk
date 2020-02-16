import './stitch_auth.dart';
import './stitch_user.dart';

/// StitchAuthListener is an interface for taking action whenever 
///  a particular [StitchAppClient]'s authentication state changes.
///
/// implement the methods in this interface to handle these events. You can 
/// register your listener with [StitchAuth] using 
/// [StitchAuth.addAuthListener].
///
/// StitchAuth calls registered listeners when:
/// - a user is added to the device for the first time
/// - a user logs in
/// - a user logs out
/// - a user is linked to another identity
/// - a listener is registered
/// - the active user is changed
/// 
/// Some actions may trigger multiple events. For instance. Logging into a 
/// user for the first time will trigger [onUserAdded], [onUserLoggedIn],
/// and [onActiveUserChanged].
/// 
// Note that callbacks in this interface are called asynchronously. This means
// that if many auth events are happening at the same time, events that 
// come in may not necessarily reflect the current state of 
/// authentication. In other words, although these methods will be 
/// called after events happen, those events may be stale by the time the 
/// listener method is called. Always check the state of [StitchAuth] 
/// object for the true authentication state.

abstract class StitchAuthListener {
  /// onAuthEvent is deprecated! Use the other event methods for more detailed 
  /// information about the auth event that has occurred.
  ///
  /// onAuthEvent is called any time the following events occur
  /// * When a user logs in.
  /// * When a user logs out.
  /// * When a user is linked to another identity.
  /// * When a listener is registered. This is to handle the case where during 
  ///   registration an event happens that the registerer would otherwise miss 
  ///   out on.
  /// * When the active user has been switched.
  ///
  /// The [StitchAuth] instance itself is passed to this callback. This can be 
  /// used to read the current state of authentication.
  /// 
  onAuthEvent(StitchAuth auth);

  /// Called whenever a user is added to the device for the first time.
  ///
  /// If this is as part of a login, this method will be called before
  /// [onUserLoggedIn] and [onActiveUserChanged] are called.
  onUserAdded(StitchAuth auth, StitchUser addedUser);

  /// Called whenever a user is linked to a new identity.
  /// 
  /// Parameter auth is the instance of [StitchAuth] where the user was linked. It 
  ///             can be used to infer the current state of authentication.
  //  Parameter linkedUser is the user that was linked to a new identity.
  onUserLinked(StitchAuth auth, StitchUser linkedUser);

  /// Called whenever a user is logged in. This will be called before 
  /// [onActiveUserChanged] is called.
  /// 
  /// If an anonymous user was already logged in on the device, and you 
  ///       log in with an [AnonymousCredential], this method will not be 
  ///       called, as the underlying [StitchAuth] will reuse the anonymous 
  ///       user's existing session, and will thus only trigger 
  ///       [onActiveUserChanged].
  onUserLoggedIn(StitchAuth auth, StitchUser loggedInUser);

  /// Called whenever a user is logged out.
  /// 
  /// The user logged out is not necessarily the active user.
  /// 
  /// If the user who logged out was the active user, then [onActiveUserChanged]
  /// will be called after this method.
  /// 
  /// If the user was an anonymous user, that user will also be removed and 
  /// [onUserRemoved] will also be called.
  onUserLoggedOut(StitchAuth auth, StitchUser loggedOutUser);

  /// Called whenever the active user changes.
  /// 
  /// Any of the following functions may trigger this event:
  /// - [StitchAuth.loginWithCredential]
  /// - [StitchAuth.switchToUserWithId]
  /// - [StitchAuth.logout]
  /// - [StitchAuth.logoutUserWithId]
  /// - [StitchAuth.removeUser]
  /// - [StitchAuth.removeUserWithId]
  /// 
  /// This may also occur on a CRUD operation or Stitch Function call if a user's
  /// session is invalidated and they are forced to log out.
  onActiveUserChanged(
    StitchAuth auth,
    [
      StitchUser currentActiveUser, 
      StitchUser previousActiveUser
    ]
  );

  /// Called whenever a user is removed from the list of users on the device,
  /// i.e. with [[StitchAuth.removeUser]] or [[StitchAuth.removeUserWithId]].
  ///
  /// Anonymous users are automatically removed when logged out.
  onUserRemoved(StitchAuth auth, StitchUser removedUser);

  /// Called whenever this listener is registered for the first time. This can 
  /// be useful to infer the state of authentication, because any events that 
  /// occurred before the listener was registered will not be seen by the 
  /// listener.
  /// 
  onListenerRegistered(StitchAuth auth);
}
