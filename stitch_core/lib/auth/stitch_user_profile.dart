
/// The set of properties that describe a MongoDB Stitch user.
abstract class StitchUserProfile {
  /// The full name of the user.
  String name;

  /// The email address of the user.
  String email;
  
  /// A Url to the user's profile picture.
  String pictureUrl;

  /// The first name of the user.
  String firstName;

  /// The last name of the user.
  String lastName;

  /// The gender of the user.
  String gender;

  /// The birthdate of the user.
  String birthday;

  /// The minimum age of the user.
  String minAge;

  /// The maximum age of the user.
  String maxAge;
}
