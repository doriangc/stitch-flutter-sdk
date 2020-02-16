import '../../internal/net/stitch_routes.dart' show getFunctionCallRoute;

class StitchServiceRoutes {
  final String functionCallRoute;
  final String _clientAppId;

  StitchServiceRoutes(String clientAppId)
      : _clientAppId = clientAppId,
        this.functionCallRoute = getFunctionCallRoute(clientAppId);
}
