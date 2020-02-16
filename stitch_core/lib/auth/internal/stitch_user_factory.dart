import './stitch_user_profile_impl.dart' show StitchUserProfileImpl;
import './core_stitch_user.dart' show CoreStitchUser;

// An interface describing a factory that produces a generic Stitch user object conforming to `CoreStitchUser`.
abstract class StitchUserFactory<T extends CoreStitchUser> {
  // The factory function which will produce the user with the provided id,
  // logged in provider type/name, logged in status, last auth activity
  // timestamp, and a user profile.
  T makeUser(String id, String loggedInProviderType,
      String loggedInProviderName, bool isLoggedIn, DateTime lastAuthActivity,
      [StitchUserProfileImpl userProfile, Map<String, dynamic> customData]);
}
