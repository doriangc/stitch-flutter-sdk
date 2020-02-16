import '../../provider_capabilities.dart' show ProviderCapabilities;
import '../../stitch_credential.dart' show StitchCredential;
import './google_auth_provider.dart' show GoogleAuthProvider;

class Fields {
  static const String AUTH_CODE = 'authCode';
}

/// A credential which can be used to log in as a Stitch user
/// using the Google authentication provider.
///
/// Browser SDK users can use the 
/// [GoogleRedirectCredential](https://docs.mongodb.com/stitch-sdks/js/4/classes/googleredirectcredential.html)
/// with [StitchAuth.loginWithRedirect](https://docs.mongodb.com/stitch-sdks/js/4/interfaces/stitchauth.html#loginwithredirect).
/// Server and React Native SDK users must obtain their own server auth code.
/// Use a third-party module to get this code and pass it to the GoogleCredential
/// constructor.
class GoogleCredential implements StitchCredential {
  /// The name of the provider for this credential.
  String providerName;

  /// The type of the provider for this credential.
  String providerType = GoogleAuthProvider.TYPE;

  /// The contents of this credential as they will be passed to the Stitch server.
  Map<String, String> material;

  /// The behavior of this credential when logging in.
  ProviderCapabilities providerCapabilities = new ProviderCapabilities(reusesExistingSession: false);

  /// The Google OAuth2 authentication code contained within this credential.
  final String _authCode;

  GoogleCredential(
    String authCode,
    {this.providerName = GoogleAuthProvider.DEFAULT_NAME}
  ) : _authCode = authCode,
      material = { Fields.AUTH_CODE: authCode};
}