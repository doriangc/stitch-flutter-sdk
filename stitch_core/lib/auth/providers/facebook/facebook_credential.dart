import '../../provider_capabilities.dart' show ProviderCapabilities;
import '../../stitch_credential.dart' show StitchCredential;
import './facebook_auth_provider.dart' show FacebookAuthProvider;

class Fields {
  static const String ACCESS_TOKEN = 'accessToken';
}

/// A credential which can be used to log in as a Stitch user
/// using the Facebook authentication provider.
///
/// Browser SDK users can use the 
/// [FacebookRedirectCredential](https://docs.mongodb.com/stitch-sdks/js/4/classes/facebookredirectcredential.html)
/// with [StitchAuth.loginWithRedirect](https://docs.mongodb.com/stitch-sdks/js/4/interfaces/stitchauth.html#loginwithredirect).
/// Server and React Native SDK users must obtain their own access token.
/// Use a third-party module to get this token and pass it to the FacebookCredential
/// constructor.
class FacebookCredential implements StitchCredential {
  ProviderCapabilities providerCapabilities = ProviderCapabilities(reusesExistingSession: false);

  String providerName;
  String providerType = FacebookAuthProvider.TYPE;

  Map<String, String> material;

  String accessToken;

  FacebookCredential(
    this.accessToken,
    {this.providerName = FacebookAuthProvider.DEFAULT_NAME}
  ) : this.material = { Fields.ACCESS_TOKEN: accessToken };
}
