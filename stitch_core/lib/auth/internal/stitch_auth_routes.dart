/// An interface representing the authentication API routes on the Stitch server.
abstract class StitchAuthRoutes {
  /// The route on the server for getting a new access token.
  String sessionRoute;

  /// The route on the server for fetching the currently authenticated user's profile.
  String profileRoute;

  /// The base route on the server for authentication-related actions.
  String baseAuthRoute;

  /// Returns the route on the server for getting information about a particular authentication provider.
  String getAuthProviderRoute(String providerName);

  /// Returns the route on the server for logging in with a particular authentication provider.
  String getAuthProviderLoginRoute(String providerName);

  /// Returns the route on the server for linking the currently authenticated user with an identity associated with a
  /// particular authentication provider.
  String getAuthProviderLinkRoute(String providerName);

  getAuthProviderExtensionRoute(String providerName, String path);
}
