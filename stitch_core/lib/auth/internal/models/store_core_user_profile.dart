import '../stitch_user_profile_impl.dart' show StitchUserProfileImpl;
import './store_stitch_user_identity.dart' show StoreStitchUserIdentity;

class Fields {
  static const String DATA = "data";
  static const String USER_TYPE = "type";
  static const IDENTITIES = 'identities';
}

/// A class describing the structure of how user profile information is stored in persisted `Storage`.
class StoreCoreUserProfile extends StitchUserProfileImpl {
  final String userType;
  final Map<String, dynamic> data;
  final List<StoreStitchUserIdentity> identities;

  static StoreCoreUserProfile decode(Map<String, dynamic> from) {
    if (from == null) return null;

    List<StoreStitchUserIdentity> identities = [];
    
    from[Fields.IDENTITIES].forEach((obj) {
      identities.add(StoreStitchUserIdentity.decode(obj));
    });

    return new StoreCoreUserProfile(
            from[Fields.USER_TYPE],
            from[Fields.DATA],
            identities);
  }

  /// New class for storing core user profile.
  StoreCoreUserProfile(this.userType, this.data, this.identities)
      : super(userType: userType, data: data, identities: identities);

  Map<String, dynamic> encode() {
    List<Map<String, dynamic>> sIdentities = [];
    identities.forEach((obj) {
      sIdentities.add(obj.encode());
    });

    return {
      Fields.DATA: this.data,
      Fields.USER_TYPE: this.userType,
      // Fields.IDENTITIES: this.identities.map((identity) => identity.encode())
      Fields.IDENTITIES: sIdentities
    };
  }
}
