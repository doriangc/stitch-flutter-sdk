import '../../provider_capabilities.dart' show ProviderCapabilities;
import '../../stitch_credential.dart' show StitchCredential;
import './server_api_key_auth_provider.dart' show ServerApiKeyAuthProvider;

class Fields {
  static const String KEY = 'key';
}

/// A credential which can be used to log in as a Stitch user
/// using the Server API Key authentication provider.
class ServerApiKeyCredential implements StitchCredential {
  /// The name of the provider for this credential.
  String providerName;

  /// The type of the provider for this credential.
  String providerType = ServerApiKeyAuthProvider.TYPE;

  /// The contents of this credential as they will be passed to the Stitch server.
  Map<String, String> material;

  /// The behavior of this credential when logging in.
  ProviderCapabilities providerCapabilities =
      ProviderCapabilities(reusesExistingSession: false);

  /// The server API key contained within this credential.
  final String _key;

  ServerApiKeyCredential(String key,
      {this.providerName = ServerApiKeyAuthProvider.DEFAULT_NAME})
      : _key = key,
        this.material = {Fields.KEY: key};
}
