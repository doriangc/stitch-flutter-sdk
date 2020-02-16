
import '../auth_info.dart' show AuthInfo;

class Fields {
  static const String USER_ID = 'user_id';
  static const String DEVICE_ID = 'device_id';
  static const String ACCESS_TOKEN = 'access_token';
  static const String REFRESH_TOKEN = 'refresh_token';
}

/// A class containing the fields returned by the Stitch client API in an authentication request.
class ApiAuthInfo extends AuthInfo {
  static ApiAuthInfo fromJSON(Map<String, dynamic> json) {
    return ApiAuthInfo(
      json[Fields.USER_ID],
      json[Fields.DEVICE_ID],
      json[Fields.ACCESS_TOKEN],
      json[Fields.REFRESH_TOKEN]
    );
  }

  ApiAuthInfo(
    String userId,
    String deviceId,
    String accessToken,
    [String refreshToken]
  ) : super(userId, deviceId, accessToken, refreshToken);

  Map<String, String> toJSON() {
    return {
      Fields.USER_ID: this.userId,
      Fields.DEVICE_ID: this.deviceId,
      Fields.ACCESS_TOKEN: this.accessToken,
      Fields.REFRESH_TOKEN: this.refreshToken
    };
  }
}
