import '../auth/internal/stitch_auth_request_client.dart'
    show StitchAuthRequestClient;
import '../internal/common/codec.dart' show Decoder;
import '../internal/net/stitch_app_routes.dart' show StitchAppRoutes;
import '../services/internal/core_stitch_service_client.dart'
    show CoreStitchServiceClient;
import '../services/internal/core_stitch_service_client_impl.dart'
    show CoreStitchServiceClientImpl;

class CoreStitchAppClient {
  final CoreStitchServiceClient _functionService;

  CoreStitchAppClient(
    StitchAuthRequestClient authRequestClient,
    StitchAppRoutes routes,
  ) : _functionService = CoreStitchServiceClientImpl(
          authRequestClient,
          routes.serviceRoutes,
        );

  Future<T> callFunction<T>(String name, List<dynamic> args,
      [Decoder<T> decoder]) {
    return _functionService.callFunction(name, args, decoder);
  }
}
