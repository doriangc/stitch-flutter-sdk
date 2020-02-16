import 'package:stitch_core/stitch_core.dart' show StitchAppRoutes;
import './stitch_browser_app_auth_routes.dart' show StitchBrowserAppAuthRoutes;

class StitchBrowserAppRoutes extends StitchAppRoutes {
  final StitchBrowserAppAuthRoutes authRoutes;

  StitchBrowserAppRoutes(String clientAppId) :
    this.authRoutes = new StitchBrowserAppAuthRoutes(clientAppId),
    super(clientAppId);
}
