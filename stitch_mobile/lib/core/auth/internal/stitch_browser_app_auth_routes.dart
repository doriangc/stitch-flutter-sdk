import 'dart:convert';

import 'package:stitch_core/stitch_core.dart' show customBase64Encode, StitchAppAuthRoutes;
import '../providers/stitch_redirect_credential.dart' show StitchRedirectCredential;

class StitchBrowserAppAuthRoutes extends StitchAppAuthRoutes {
  StitchBrowserAppAuthRoutes(String clientAppId) :
    super(clientAppId);

  String getAuthProviderRedirectRoute(
    StitchRedirectCredential credential,
    String redirectUrl,
    String state,
    Map<String, dynamic> deviceInfo
  ) {
    return '${getAuthProviderLoginRoute(
      credential.providerName
    )}?redirect=${Uri.encodeFull(
      redirectUrl
    )}&state=$state&device=${this.uriEncodeObject(deviceInfo)}';
  }

  String getAuthProviderLinkRedirectRoute(
    StitchRedirectCredential credential,
    String redirectUrl,
    String state,
    Map<String, dynamic> deviceInfo
  ) {
    return '${getAuthProviderLoginRoute(
      credential.providerName
    )}?redirect=${Uri.encodeFull(
      redirectUrl
    )}&state=$state&device=${uriEncodeObject(
      deviceInfo
    )}&link=true&providerRedirectHeader=true';
  }

  /// Utility function to encode a JSON object into a valid string that can be
  /// inserted in a URI. The object is first stringified, then encoded in base64,
  /// and finally encoded via the builtin encodeURIComponent function.
  String uriEncodeObject(Map<String, dynamic> obj) {
    return Uri.encodeFull(customBase64Encode(json.encode(obj)));
  }
}