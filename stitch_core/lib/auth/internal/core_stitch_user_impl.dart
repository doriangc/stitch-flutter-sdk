import './stitch_user_profile_impl.dart' show StitchUserProfileImpl;
import '../stitch_user_identity.dart' show StitchUserIdentity;
import './core_stitch_user.dart' show CoreStitchUser;

/// The set of properties that describe an authenticated Stitch user.
class CoreStitchUserImpl extends CoreStitchUser {
  /// The id of the Stitch user.
  final String id;

  /// The type of authentication provider used to log in as this user.
  final String loggedInProviderType;

  /// The name of the authentication provider used to log in as this user.
  final String loggedInProviderName;

  /// A `StitchUserProfile` object describing this user.
  final StitchUserProfileImpl profile;

  final bool isLoggedIn;

  final DateTime lastAuthActivity;

  Map<String, dynamic> customData;

  CoreStitchUserImpl(
    this.id,
    this.loggedInProviderType,
    this.loggedInProviderName,
    this.isLoggedIn,
    this.lastAuthActivity,
    [profile,
    customData]
  ) : 
    this.profile = profile ?? StitchUserProfileImpl.empty(),
    this.customData = customData ?? {};

  /// A string describing the type of this user. (Either `server` or `normal`)
  String get userType => this.profile.userType;

  /// An array of `StitchUserIdentity` objects representing the identities linked
  /// to this user which can be used to log in as this user.
  List<StitchUserIdentity> get identities {
    return this.profile.identities;
  }

  /// Returns whether this core Stitch user is equal to another in every 
  /// property except lastAuthActivity. This should be used for testing 
  /// purposes only.
  //  * @param other The CoreStitchUserImpl to compare with
  //  */
  // public equals(other: CoreStitchUserImpl): boolean {
  //   return this.id === other.id
  //     && JSON.stringify(this.identities) === JSON.stringify(other.identities)
  //     && this.isLoggedIn === other.isLoggedIn
  //     && this.loggedInProviderName === other.loggedInProviderName
  //     && this.loggedInProviderType === other.loggedInProviderType
  //     && JSON.stringify(this.profile) === JSON.stringify(other.profile)
  // }
}
