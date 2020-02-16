import 'package:stitch_core/stitch_core.dart' show StitchAuthRequestClient, StitchAuthRoutes, StitchRequestClient;

abstract class AuthProviderClientFactory<ClientT> {
  ClientT getClient(
    StitchAuthRequestClient authRequestClient,
    StitchRequestClient requestClient,
    StitchAuthRoutes routes
  );
}
