import '../../provider_capabilities.dart' show ProviderCapabilities;
import '../../stitch_credential.dart' show StitchCredential;
import './function_auth_provider.dart' show FunctionAuthProvider;

/// A credential which can be used to log in as a Stitch user
/// using the Function authentication provider.
class FunctionCredential implements StitchCredential {
  ProviderCapabilities providerCapabilities =
      ProviderCapabilities(reusesExistingSession: false);

  String providerName;
  String providerType = FunctionAuthProvider.TYPE;

  Map<String, String> material;

  FunctionCredential(Map<String, String> payload,
      {this.providerName = FunctionAuthProvider.DEFAULT_NAME}) : material = payload;
}
