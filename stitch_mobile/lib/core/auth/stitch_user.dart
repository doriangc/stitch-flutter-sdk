
import 'package:stitch_core/stitch_core.dart' show
  CoreStitchUser, 
  StitchCredential, 
  StitchUserIdentity,
  StitchUserProfile;

/// The StitchUser represents the currently logged-in user of the [StitchAppClient].
/// 
/// This can be retrieved from [StitchAuth] or from the result of certain methods
/// such as [StitchAuth.loginWithCredential] or [StitchAuth.handleRedirectResult].
abstract class StitchUser extends CoreStitchUser {
  /// The String representation of the ID of this Stitch user.
  String id;

  /// The time of the last auth event involving this user. 
  /// This includes login, logout, and active user changed.
  DateTime lastAuthActivity;

  /// The type of authentication provider used to log in as this user.
  String loggedInProviderType;

  /// The name of the authentication provider used to log in as this user.
  String loggedInProviderName;

  /// Whether or not this user is logged in.
  /// 
  /// If the user is logged in, it can be switched to without reauthenticating 
  /// using [StitchAuth.switchToUserWithId].
  /// 
  /// This is not a dynamic property. This is the state of whether or not
  /// the user was logged in at the time this user object was created.
  /// Use [StitchAuth.listUsers] to get a new list of users with current state.
  bool isLoggedIn;

  /// A string describing the type of this user: either `server` or `normal`.
  String userType;

  /// A [StitchUserProfile] object describing this user.
  StitchUserProfile profile;

  /// An array of [StitchUserIdentity] objects representing the identities 
  /// linked to this user which can be used to log in as this user.
  List<StitchUserIdentity> identities;

  /// You can store arbitrary data about your application users
  /// in a MongoDB collection and configure Stitch to automatically
  /// expose each user’s data in a field of their user object.
  /// For example, you might store a user’s preferred language,
  /// date of birth, or their local timezone.
  ///
  /// If this functionality has not been configured, it will be empty.
  Map<String, dynamic> customData;
  
  /// Links this [StitchUser] with a new identity, where the identity is 
  /// resolved via an external OAuth2 login process (e.g. Facebook or Google). 
  /// This method will redirect the user to the external login page. That 
  /// external page will redirect the user back to the page specified in the 
  /// redirect credential. To complete the link, that page will need to handle
  /// the redirect by calling [StitchAuth.handleRedirectResult()].
  /// 
  /// @param credential The redirect credential to use to link this user to a new identity.
  // Future<void> linkUserWithRedirect(StitchRedirectCredential credential);

  /// Links this [StitchUser] with a new identity, where the identity is 
  /// defined by the credential specified as a parameter. This will only be 
  /// successful if this [StitchUser] is the currently authenticated 
  /// [StitchUser] for the client from which it was created.
  Future<StitchUser> linkWithCredential(StitchCredential credential);
}
