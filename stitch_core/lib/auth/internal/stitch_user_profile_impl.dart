import '../stitch_user_identity.dart' show StitchUserIdentity;
import '../stitch_user_profile.dart' show StitchUserProfile;

const NAME = "name";
const EMAIL = "email";
const PICTURE_URL = "picture";
const FIRST_NAME = "first_name";
const LAST_NAME = "last_name";
const GENDER = "gender";
const BIRTHDAY = "birthday";
const MIN_AGE = "min_age";
const MAX_AGE = "max_age";

/// A class containing the fields returned by the Stitch client API in a user profile request.
class StitchUserProfileImpl extends StitchUserProfile {
  static StitchUserProfileImpl empty() {
    return StitchUserProfileImpl();
  }

  /// A string describing the type of this user. (Either `server` or `normal`)
  final String userType;

  /// An object containing extra metadata about the user as supplied by the authentication provider.
  final Map<String, dynamic> data;

  /// An array of `StitchUserIdentity` objects representing the identities linked
  /// to this user which can be used to log in as this user.
  final List<StitchUserIdentity> identities;

  StitchUserProfileImpl(
      {this.userType, this.data = const {}, this.identities = const []});

  /// The full name of the user.
  String get name {
    return this.data[NAME];
  }

  /// The email address of the user.
  String get email {
    return this.data[EMAIL];
  }

  /// A Url to the user's profile picture.
  String get pictureUrl {
    return this.data[PICTURE_URL];
  }

  /// The first name of the user.
  String get firstName {
    return this.data[FIRST_NAME];
  }

  /// The last name of the user.
  String get lastName {
    return this.data[LAST_NAME];
  }

  /// The gender of the user.
  String get gender {
    return this.data[GENDER];
  }

  /// The birthdate of the user.
  String get birthday {
    return this.data[BIRTHDAY];
  }

  /// The minimum age of the user.
  String get minAge {
    String age = data[MIN_AGE];
    if (age == null) {
      return null;
    }
    return age;
  }

  /// The maximum age of the user.
  String get maxAge {
    var age = this.data[MAX_AGE];
    if (age == null) {
      return null;
    }
    return age;
  }
}
