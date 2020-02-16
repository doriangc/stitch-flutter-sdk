import '../stitch_user_profile_impl.dart' show StitchUserProfileImpl;
import './api_stitch_user_identity.dart' show ApiStitchUserIdentity;

class Fields {
  static const String DATA = 'data';
  static const String USER_TYPE = 'type';
  static const String IDENTITIES = 'identities';
}


/// A class containing the fields returned by the Stitch client API in the
/// `data` field of a user profile request.
class ApiCoreUserProfile extends StitchUserProfileImpl {
  static fromJSON(Map<String, dynamic> json) {
    List<ApiStitchUserIdentity> identities = [];
    json[Fields.IDENTITIES].forEach((obj){
      identities.add(ApiStitchUserIdentity.fromJSON(obj));
    });

    return ApiCoreUserProfile(
      json[Fields.USER_TYPE],
      json[Fields.DATA],
      identities
    );
  }

  ApiCoreUserProfile(
    String userType,
    Map<String, dynamic> data,
    List<ApiStitchUserIdentity> identities
  ) : super(userType: userType, data: data, identities: identities);

  Map<String, dynamic> toJSON() {
    return {
      Fields.DATA: this.data,
      Fields.USER_TYPE: this.userType,
      Fields.IDENTITIES: this.identities
    };
  }
}
