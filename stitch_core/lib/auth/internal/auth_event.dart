// TODO: Fix Double references to AuthEventKind (can be inferenced from class name)

import './core_stitch_user.dart' show CoreStitchUser;

enum AuthEventKind {
  ActiveUserChanged,
  ListenerRegistered,
  UserAdded,
  UserLinked,
  UserLoggedIn,
  UserLoggedOut,
  UserRemoved,
}

abstract class AuthEvent<TStitchUser extends CoreStitchUser> { // passed in type must be descendant of CoreStitchUser
  final AuthEventKind kind;
  AuthEvent(this.kind);
}

class ActiveUserChanged<TStitchUser extends CoreStitchUser> extends AuthEvent<TStitchUser> {
  final TStitchUser currentActiveUser;
  final TStitchUser previousActiveUser;
  ActiveUserChanged({this.currentActiveUser, this.previousActiveUser}) : super(AuthEventKind.ActiveUserChanged);
}

class ListenerRegistered<FakeStitchUser extends CoreStitchUser> extends AuthEvent<FakeStitchUser> {
  ListenerRegistered() : super(AuthEventKind.ListenerRegistered);
}

class UserAdded<TStitchUser extends CoreStitchUser> extends AuthEvent<TStitchUser> {
  final TStitchUser addedUser;
  UserAdded(this.addedUser) : super(AuthEventKind.UserAdded);
}

class UserLinked<TStitchUser extends CoreStitchUser> extends AuthEvent<TStitchUser> {
  final TStitchUser linkedUser;
  UserLinked(this.linkedUser) : super(AuthEventKind.UserLinked);
}

class UserLoggedIn<TStitchUser extends CoreStitchUser> extends AuthEvent<TStitchUser> {
  TStitchUser loggedInUser;
  UserLoggedIn(this.loggedInUser) : super(AuthEventKind.UserLoggedIn);
}

class UserLoggedOut<TStitchUser extends CoreStitchUser> extends AuthEvent<TStitchUser> {
  final TStitchUser loggedOutUser;
  UserLoggedOut(this.loggedOutUser) : super(AuthEventKind.UserLoggedOut);
}

class UserRemoved<TStitchUser extends CoreStitchUser> extends AuthEvent<TStitchUser> {
  final TStitchUser removedUser;
  UserRemoved(this.removedUser) : super(AuthEventKind.UserRemoved);
}
