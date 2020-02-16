import '../../provider_capabilities.dart' show ProviderCapabilities;
import '../../stitch_credential.dart' show StitchCredential;
import './user_api_key_auth_provider.dart' show UserApiKeyAuthProvider;

class Fields {
  static const String KEY = 'key';
}

/// A credential which can be used to log in as a Stitch user
/// using the User API Key authentication provider.
class UserApiKeyCredential implements StitchCredential {
  /// The name of the provider for this credential.
  String providerName;

  /// The user API key contained within this credential.
  String key;

  /// The type of the provider for this credential.
  String providerType = UserApiKeyAuthProvider.TYPE;

  /// The contents of this credential as they will be passed to the Stitch server.
  Map<String, String> material;

  /// The behavior of this credential when logging in.
  ProviderCapabilities providerCapabilities =
      ProviderCapabilities(reusesExistingSession: false);

  UserApiKeyCredential(this.key,
      {this.providerName = UserApiKeyAuthProvider.DEFAULT_NAME})
      : material = {Fields.KEY: key};
}
