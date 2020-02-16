// Derivated from Copyright work by MongoDB, inc. (Copyright 2018-present MongoDB, Inc.)

import '../stitch_user_identity.dart';
import '../stitch_user_profile.dart';

abstract class CoreStitchUser {
  /// The id of the Stitch user.
  String id;
  
  /// The type of authentication provider used to log in as this user.
  String loggedInProviderType;

  //// The name of the authentication provider used to log in as this user.
  String loggedInProviderName;

  
  /// A string describing the type of this user. (Either `server` or `normal`)
  String userType;
  
  
  /// A `StitchUserProfile` object describing this user.
  StitchUserProfile profile;
  
  
  /// An array of `StitchUserIdentity` objects representing the identities linked
  /// to this user which can be used to log in as this user.
  List<StitchUserIdentity> identities;

  
  /// Whether or not this user is logged in. If the user is logged in, it can be
  /// switched to without reauthenticating. 
  /// 
  /// This is not a dynamic property, this is the state of whether or not 
  ///      the user was logged in at the time this user object was created.
  bool isLoggedIn;

  /// The time of the last auth event involving this user. 
  /// This includes login, logout, and active user changed.
  DateTime lastAuthActivity;

  /// You can store arbitrary data about your application users
  /// in a MongoDB collection and configure Stitch to automatically
  /// expose each user’s data in a field of their user object.
  /// For example, you might store a user’s preferred language,
  /// date of birth, or their local timezone.
  ///
  /// If this value has not been configured, it will be empty.
  Map<String, dynamic> customData;
}
