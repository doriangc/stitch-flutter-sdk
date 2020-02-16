import 'package:stitch_core/stitch_core.dart' show StitchAuthRequestClient, StitchAuthRoutes, StitchRequestClient;

import '../internal/auth_provider_client_factory.dart' show AuthProviderClientFactory;
import './internal/user_password_auth_provider_client_impl.dart' show UserPasswordAuthProviderClientImpl;

/// A client for interacting with username/password authentication provider in 
/// Stitch.
abstract class UserPasswordAuthProviderClient {
  /// Registers a new user with the given email and password.
  Future<void> registerWithEmail(String email, String password);

  /// Confirms a user with the given token and token id.
  Future<void> confirmUser(String token, String tokenId);

  /// Resend the confirmation for a user to the given email.
  Future<void> resendConfirmationEmail(String email);

  /// Reset the password of a user with the given token, token id, and new password.
  Future<void> resetPassword(
    String token,
    String tokenId,
    String password
  );

  /// Sends a user a password reset email for the given email.
  Future<void> sendResetPasswordEmail(String email);

  /// Call a reset password function configured to the provider.
  Future<void> callResetPasswordFunction(String email, String password, List<dynamic> args);
}

class UserPasswordAuthProviderClientFactory implements AuthProviderClientFactory<UserPasswordAuthProviderClient> {
    UserPasswordAuthProviderClient getClient(
      StitchAuthRequestClient authRequestClient, // This arg is ignored
      StitchRequestClient requestClient,
      StitchAuthRoutes routes
    ) {
      return new UserPasswordAuthProviderClientImpl(requestClient, routes);
    }
}
