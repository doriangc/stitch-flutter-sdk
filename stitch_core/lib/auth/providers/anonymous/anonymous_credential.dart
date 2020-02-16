import '../../provider_capabilities.dart' show ProviderCapabilities;
import '../../stitch_credential.dart' show StitchCredential;
import './anonymous_auth_provider.dart' show AnonymousAuthProvider;

/// The AnonymousCredential is a [[StitchCredential]] that logs in
/// using the [Anonymous Authentication Provider](https://docs.mongodb.com/stitch/authentication/anonymous/).
class AnonymousCredential implements StitchCredential {
  /// The name of the provider for this credential.
  String providerName;

  /// The type of the provider for this credential.
  String providerType = AnonymousAuthProvider.TYPE;

  /// The contents of this credential as they will be passed to the Stitch server.
  Map<String, String> material = {};
  
  /// The behavior of this credential when logging in.
  ProviderCapabilities providerCapabilities = ProviderCapabilities(reusesExistingSession: true);

  AnonymousCredential({this.providerName = AnonymousAuthProvider.DEFAULT_NAME}) {
    this.providerName = providerName;
  }
}
