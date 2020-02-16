/// The class from which all Core auth provider clients inherit. Only auth
/// provider clients that make requests to the Stitch server need to inherit this class.
abstract class CoreAuthProviderClient<RequestClientType> {
  final String providerName;

  final RequestClientType requestClient;
  final String baseRoute;

  /// Construct a new CoreAuthProviderClient
  /// @param providerName The name of the authentication provider.
  /// @param requestClient The request client used by the client to make requests.
  /// Is of a generic type since some auth provider clients
  /// use an authenticated request client while others use an unauthenticated request client.
  /// @param baseRoute The base route for this authentication provider client.
  CoreAuthProviderClient(
    this.providerName,
    this.requestClient,
    this.baseRoute
  );
}