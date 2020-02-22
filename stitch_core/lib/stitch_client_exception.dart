import 'stitch_exception.dart';

class StitchClientExceptionCode {
  static final loggedOutDuringRequest = 'Logged out while making a request to Stitch';
  static final mustAuthenticateFirst = 'method called requires being authenticated';
  static final userNoLongerValid = 'user instance being accessed is no longer valid; please get a new user with auth.getUser()';
  static final userNotFound = 'user not found in list of users';
  static final userNotLoggedIn = 'cannot make the active user a logged out user; please use loginWithCredential() to switch to this user';
  static final couldNotLoadPersistedAuthInfo = 'failed to load stored auth information for Stitch';
  static final couldNotPersistAuthInfo = 'failed to save auth information for Stitch';
  static final streamingNotSupported = 'streaming not supported in this SDK';
  static final streamClosed = 'stream is closed';
  static final unexpectedArguments = 'function does not accept arguments';
}

class StitchClientException extends StitchException {
 StitchClientException([String message]) : super(message); 
}

class StitchDecodingException extends StitchException {
  StitchDecodingException([String message]) : super(message); 
}
