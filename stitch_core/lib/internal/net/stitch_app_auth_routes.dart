import '../../auth/internal/stitch_auth_routes.dart' show StitchAuthRoutes;
import './stitch_routes.dart' show BASE_ROUTE, getAppRoute;

String getAuthProviderRouteO(
  String clientAppId,
  String providerName
) {
  return getAppRoute(clientAppId) + '/auth/providers/$providerName';
}

String getAuthProviderLoginRouteO(
  String clientAppId,
  String providerName
) {
  return getAuthProviderRouteO(clientAppId, providerName) + "/login";
}

String getAuthProviderLinkRouteO(
  String clientAppId,
  String providerName
) {
  return getAuthProviderLoginRouteO(clientAppId, providerName) + "?link=true";
}

class StitchAppAuthRoutes implements StitchAuthRoutes {
  String baseAuthRoute = '$BASE_ROUTE/auth';

  String sessionRoute;
  String profileRoute;

  final String _clientAppId;

  StitchAppAuthRoutes(String clientAppId) :
    _clientAppId = clientAppId {
      sessionRoute = '$baseAuthRoute/session';
      profileRoute = '$baseAuthRoute/profile';
    }

  String getAuthProviderRoute(String providerName) {
    return getAuthProviderRouteO(_clientAppId, providerName);
  }

  String getAuthProviderLoginRoute(String providerName) {
    return getAuthProviderLoginRouteO(_clientAppId, providerName);
  }

  String getAuthProviderLinkRoute(String providerName) {
    return getAuthProviderLinkRouteO(_clientAppId, providerName);
  }

  String getAuthProviderExtensionRoute(String providerName, String path) {
    return '${this.getAuthProviderRoute(providerName)}/$path';
  }
}