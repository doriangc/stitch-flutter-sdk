
import './stitch_user_profile_impl.dart' show StitchUserProfileImpl;

/// A class representing the combined information represented by a user.
class AuthInfo {
  static AuthInfo empty() {
    return AuthInfo();
  }

  /// Whether or not this auth info is associated with a user.
  bool get hasUser {
    return this.userId != null;
  }

  /// An empty auth info is an auth info associated with no device ID.
  bool get isEmpty {
    return this.deviceId == null;
  }

  /// The id of the Stitch user.
  final String userId;

  /// The device id.
  final String deviceId;

  /// The temporary access token for the user.
  final String accessToken;
  
  /// The permanent (though potentially invalidated) refresh token for the user.
  final String refreshToken;

  /// The type of authentication provider used to log into the current session.
  final String loggedInProviderType;
  
  /// A string indicating the name of authentication provider used to log into the current session.
  final String loggedInProviderName;

  /// The profile of the currently authenticated user as a `StitchUserProfile`.
  final StitchUserProfileImpl userProfile;

  /// The time of the last auth event involving this user. 
  /// This includes login, logout, and active user changed.
  final DateTime lastAuthActivity;

  AuthInfo([
    this.userId,
    this.deviceId,
    this.accessToken,
    this.refreshToken,
    this.loggedInProviderType,
    this.loggedInProviderName,
    this.lastAuthActivity,
    this.userProfile
  ]);

  AuthInfo loggedOut() {
    return AuthInfo(
      userId,
      deviceId,
      null,
      null,
      loggedInProviderType,
      loggedInProviderName,
      DateTime.now(),
      userProfile,
    );
  }

  AuthInfo withClearedUser() {
    return AuthInfo(
      null,
      deviceId,
      null,
      null,
      null,
      null,
      null,
      null
    );
  }

  withAuthProvider(String providerType, String providerName) {
    return AuthInfo(
      userId,
      deviceId,
      accessToken,
      refreshToken,
      providerType,
      providerName,
      DateTime.now(),
      userProfile,
    );
  }

  withNewAuthActivityTime() {
    return new AuthInfo(
      userId,
      deviceId,
      accessToken,
      refreshToken,
      loggedInProviderType,
      loggedInProviderName,
      DateTime.now(),
      userProfile
    );
  }

  bool get isLoggedIn {
    return this.accessToken != null && this.refreshToken != null;
  }

  /// Merges a new `AuthInfo` into some existing `AuthInfo`.
  AuthInfo merge(AuthInfo newInfo) {
    return AuthInfo(
      newInfo.userId == null ? this.userId : newInfo.userId,
      newInfo.deviceId == null ? this.deviceId : newInfo.deviceId,
      newInfo.accessToken == null
        ? this.accessToken
        : newInfo.accessToken,
      newInfo.refreshToken == null
        ? this.refreshToken
        : newInfo.refreshToken,
      newInfo.loggedInProviderType == null
        ? this.loggedInProviderType
        : newInfo.loggedInProviderType,
      newInfo.loggedInProviderName == null
        ? this.loggedInProviderName
        : newInfo.loggedInProviderName,
      newInfo.lastAuthActivity == null
        ? this.lastAuthActivity
        : newInfo.lastAuthActivity,
      newInfo.userProfile == null 
        ? this.userProfile 
        : newInfo.userProfile,
    );
  }
}
