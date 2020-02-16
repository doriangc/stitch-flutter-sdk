
import '../../auth/internal/stitch_auth_routes.dart' show StitchAuthRoutes;
import '../../services/internal/stitch_service_routes.dart' show StitchServiceRoutes;
import './stitch_app_auth_routes.dart' show StitchAppAuthRoutes;
import './stitch_routes.dart' show getAppMetadataRoute, getFunctionCallRoute;

class StitchAppRoutes {
  final StitchAuthRoutes authRoutes;
  final StitchServiceRoutes serviceRoutes;

  final String functionCallRoute;
  final String appMetadataRoute;
  final String clientAppId;

  StitchAppRoutes(this.clientAppId) :
    this.authRoutes = new StitchAppAuthRoutes(clientAppId),
    this.serviceRoutes = new StitchServiceRoutes(clientAppId),
    this.appMetadataRoute = getAppMetadataRoute(clientAppId),
    this.functionCallRoute = getFunctionCallRoute(clientAppId);
}