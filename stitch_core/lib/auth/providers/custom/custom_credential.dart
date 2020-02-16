import '../../provider_capabilities.dart' show ProviderCapabilities;
import '../../stitch_credential.dart' show StitchCredential;
import './custom_auth_provider.dart' show CustomAuthProvider;

class Fields {
  static const String TOKEN = 'token';
}

/// A credential which can be used to log in as a Stitch user
/// using the Custom authentication provider.
class CustomCredential implements StitchCredential {
  /// The name of the provider for this credential.
  String providerName;

  /// The type of the provider for this credential.
  String providerType = CustomAuthProvider.TYPE;

  /// The behavior of this credential when logging in.
  ProviderCapabilities providerCapabilities =
      ProviderCapabilities(reusesExistingSession: false);

  /// The contents of this credential as they will be passed to the Stitch server.
  Map<String, String> material;

  /// The JWT contained within this credential.
  String _token;

  CustomCredential(String token,
      {this.providerName = CustomAuthProvider.DEFAULT_NAME})
      : _token = token,
        material = {Fields.TOKEN: token};
}
