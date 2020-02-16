
import './provider_capabilities.dart';

/// StitchCredential is an interface for simple login flow credentials.
/// 
/// Pass implementations to [StitchAuth.loginWithCredential] to log in as a [StitchUser].
/// 
/// Each "Authentication Provider"(https://docs.mongodb.com/stitch/authentication/)
/// in MongoDB Stitch provides a StitchCredential or StitchRedirectCredential (browser SDK only)
//  implementation. See **Implemented by** below for a list of implementations.
class StitchCredential {
  /// The name of the authentication provider that this credential will be used to authenticate with.
  String providerName;

  /// The type of the authentication provider that this credential will be used to authenticate with.
  String providerType;

  /// The contents of this credential as they will be passed to the Stitch server.
  Map<String, String> material;

  /// A [ProviderCapabilities] object describing the behavior of this credential when logging in.
  ProviderCapabilities providerCapabilities;
}
