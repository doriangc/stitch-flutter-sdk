/// A class representing an identity that a Stitch user is linked to and can use to sign into their account.
class StitchUserIdentity {
  /// The id of this identity in MongoDB Stitch
  ///
  /// This is **not** the id of the Stitch user.
  final String id;
   
  /// A string indicating the authentication provider that provides this identity.
  final String providerType;

  StitchUserIdentity(this.id, this.providerType);
}
