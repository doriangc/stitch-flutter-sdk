import '../../provider_capabilities.dart'show ProviderCapabilities;
import '../../stitch_credential.dart' show StitchCredential;
import './user_password_auth_provider.dart' show UserPasswordAuthProvider;

class Fields {
  static const String USERNAME = 'username';
  static const String PASSWORD = 'password';
}

class UserPasswordCredential implements StitchCredential {
  String providerType = UserPasswordAuthProvider.TYPE;

  Map<String, String> material;

  ProviderCapabilities providerCapabilities = ProviderCapabilities(reusesExistingSession: false);

  String username;
  String password;
  String providerName;

  UserPasswordCredential(
    this.username,
    this.password,
    [this.providerName = UserPasswordAuthProvider.DEFAULT_NAME]
  ) {
    this.material = {
      Fields.USERNAME: this.username,
      Fields.PASSWORD: this.password
    };
  }
}
