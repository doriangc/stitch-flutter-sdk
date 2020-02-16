import 'package:stitch_core/stitch_core.dart' show StitchAuthRoutes, StitchRequestClient;

abstract class NamedAuthProviderClientFactory<T> {
  T getNamedClient(
    String providerName,
    StitchRequestClient requestClient,
    StitchAuthRoutes routes
  );
}