
import '../../internal/common/base64.dart' show customBase64Decode;
import 'dart:convert';

const EXPIRES = "exp";
const ISSUED_AT = "iat";
const USER_DATA = "user_data";

/// A simple class representing a JWT issued by the Stitch server. Only contains claims relevant to the SDK.
class JWT {
  /// Initializes the `StitchJWT` with a base64-encoded string, with or without padding characters.
  static JWT fromEncoded(String encodedJWT) {
    List<String> parts = JWT._splitToken(encodedJWT);
    var jsonDecode = json.decode(customBase64Decode(parts[1]));
    var expires = jsonDecode[EXPIRES];
    var iat = jsonDecode[ISSUED_AT];
    var userData = jsonDecode[USER_DATA];
    return new JWT(expires, iat, userData);
  }

  /// Private utility function to split the JWT into its three constituent parts.
  static List<String> _splitToken(String jwt) {
    List<String> parts = jwt.split('.');
    if (parts.length != 3) {
      throw 'Malformed JWT token. The string $jwt should have 3 parts.';
    }
    return parts;
  }

  /// Per RFC 7519:
  /// 4.1.4.  "exp" (Expiration Time) Claim
  ///
  /// The "exp" (expiration time) claim identifies the expiration time on
  /// or after which the JWT MUST NOT be accepted for processing.  The
  /// processing of the "exp" claim requires that the current date/time
  /// MUST be before the expiration date/time listed in the "exp" claim.
  final num expires;

  /// Per RFC 7519:
  /// 4.1.6.  "iat" (Issued At) Claim
  ///
  /// The "iat" (issued at) claim identifies the time at which the JWT was
  /// issued.  This claim can be used to determine the age of the JWT.  Its
  /// value MUST be a number containing a NumericDate value.  Use of this
  /// claim is OPTIONAL.
  final num issuedAt;

  final Map<String, dynamic> userData;

  JWT(this.expires, this.issuedAt, [this.userData]);
}
