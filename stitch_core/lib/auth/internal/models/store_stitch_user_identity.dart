
import '../../stitch_user_identity.dart' show StitchUserIdentity;

class Fields {
  static const String ID = 'id';
  static const String PROVIDER_TYPE = 'provider_type';
}

/// A class describing the structure of how user identity information is stored in persisted `Storage`.
class StoreStitchUserIdentity extends StitchUserIdentity {
  static StoreStitchUserIdentity decode(Map<String, dynamic> from) {
    return StoreStitchUserIdentity(
      from[Fields.ID],
      from[Fields.PROVIDER_TYPE]
    );
  }

  /// The id of this identity in MongoDB Stitch
  /// - important: This is **not** the id of the Stitch user.
  String id;

  /// A string indicating the authentication provider that provides this identity.
  String providerType;

  StoreStitchUserIdentity(String id, String providerType) : super(id, providerType);

  Map<String, dynamic> encode() {
    return {
      Fields.ID: this.id,
      Fields.PROVIDER_TYPE: this.providerType
    };
  }
}
