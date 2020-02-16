import '../../internal/auth_info.dart' show AuthInfo;
import '../../provider_capabilities.dart' show ProviderCapabilities;
import '../../stitch_credential.dart' show StitchCredential;

class StitchAuthResponseCredential implements StitchCredential {
  /// A `ProviderCapabilities` object describing the behavior of this credential when logging in.
  ProviderCapabilities providerCapabilities;

  /// The contents of this credential as they will be passed to the Stitch server.
  Map<String, String> material;

  AuthInfo authInfo;
  String providerType;
  String providerName;
  bool asLink;

  /// The contents of this credential as they will be
  /// processed and stored
  StitchAuthResponseCredential(
    this.authInfo,
    this.providerType,
    this.providerName,
    this.asLink // Whether or not this credential was for a link or login request.
  );
}
