import 'package:stitch_core/stitch_core.dart' show CoreUserPasswordAuthProviderClient, StitchAppAuthRoutes, StitchRequestClient, UserPasswordAuthProvider;
import '../user_password_auth_provider_client.dart' show UserPasswordAuthProviderClient;



class UserPasswordAuthProviderClientImpl extends CoreUserPasswordAuthProviderClient implements UserPasswordAuthProviderClient {

  UserPasswordAuthProviderClientImpl(
    StitchRequestClient requestClient,
    StitchAppAuthRoutes routes
  ) : super(requestClient, routes, providerName: UserPasswordAuthProvider.DEFAULT_NAME);

  Future<void> registerWithEmail(String email, String password) {
    return super.registerWithEmailInternal(email, password);
  }

  Future<void> confirmUser(String token, String tokenId) {
    return super.confirmUserInternal(token, tokenId);
  }

  Future<void> resendConfirmationEmail(String email) {
    return super.resendConfirmationEmailInternal(email);
  }

  Future<void> resetPassword(
    String token,
    String tokenId,
    String password
  ) {
    return super.resetPasswordInternal(token, tokenId, password);
  }

  Future<void> sendResetPasswordEmail(String email) {
    return super.sendResetPasswordEmailInternal(email);
  }

  Future<void> callResetPasswordFunction(String email, String password, List<dynamic> args) {
    return super.callResetPasswordFunctionInternal(email, password, args);
  }
}
