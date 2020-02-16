
import '../../../internal/net/stitch_doc_request.dart' show StitchDocRequestBuilder;
import '../../../internal/net/stitch_request_client.dart' show StitchRequestClient;
import '../../internal/stitch_auth_routes.dart' show StitchAuthRoutes;
import '../internal/core_auth_provider_client.dart' show CoreAuthProviderClient;
import './user_password_auth_provider.dart' show UserPasswordAuthProvider;


class RegistrationFields {
  static const String EMAIL = 'email';
  static const String PASSWORD = 'password';
}

class ActionFields {
  static const String EMAIL = 'email';
  static const String PASSWORD = 'password';
  static const String TOKEN = 'token';
  static const String TOKEN_ID = 'tokenId';
  static const String ARGS = 'arguments';
}

class CoreUserPasswordAuthProviderClient extends CoreAuthProviderClient<StitchRequestClient> {
  CoreUserPasswordAuthProviderClient(
    StitchRequestClient requestClient,
    StitchAuthRoutes authRoutes,
    {String providerName = UserPasswordAuthProvider.DEFAULT_NAME}
  ) : super(providerName, requestClient, authRoutes.getAuthProviderRoute(providerName));

  Future<void> registerWithEmailInternal(
    String email,
    String password
  ) async {
    StitchDocRequestBuilder reqBuilder = StitchDocRequestBuilder();
    reqBuilder
      .withMethod('POST')
      .withPath(_getRegisterWithEmailRoute());
    reqBuilder.withDocument({
      [RegistrationFields.EMAIL]: email,
      [RegistrationFields.PASSWORD]: password
    });
    await this.requestClient.doRequest(reqBuilder.build());
  }

  Future<void> confirmUserInternal(String token, String tokenId) async {
    StitchDocRequestBuilder reqBuilder = StitchDocRequestBuilder();
    reqBuilder.withMethod('POST').withPath(_getConfirmUserRoute());
    reqBuilder.withDocument({
      [ActionFields.TOKEN]: token,
      [ActionFields.TOKEN_ID]: tokenId
    });
    await this.requestClient.doRequest(reqBuilder.build());
  }

  Future<void> resendConfirmationEmailInternal(String email) async {
    StitchDocRequestBuilder reqBuilder = StitchDocRequestBuilder();
    reqBuilder
      .withMethod('POST')
      .withPath(_getResendConfirmationEmailRoute());
    reqBuilder.withDocument({ [ActionFields.EMAIL]: email });
    await this.requestClient.doRequest(reqBuilder.build());
  }

  Future<void> resetPasswordInternal(
    String token,
    String tokenId,
    String password
  ) async {
    StitchDocRequestBuilder reqBuilder = StitchDocRequestBuilder();
    reqBuilder.withMethod('POST').withPath(_getResetPasswordRoute());
    reqBuilder.withDocument({
      [ActionFields.TOKEN]: token,
      [ActionFields.TOKEN_ID]: tokenId,
      [ActionFields.PASSWORD]: password
    });
    await this.requestClient.doRequest(reqBuilder.build());
  }

  Future<void> sendResetPasswordEmailInternal(String email) async {
    StitchDocRequestBuilder reqBuilder = StitchDocRequestBuilder();
    reqBuilder
      .withMethod('POST')
      .withPath(_getSendResetPasswordEmailRoute());
    reqBuilder.withDocument({ [ActionFields.EMAIL]: email });
    await this.requestClient.doRequest(reqBuilder.build());
  }

  Future<void> callResetPasswordFunctionInternal(String email, String password, List<dynamic> args) async {
    StitchDocRequestBuilder reqBuilder = StitchDocRequestBuilder();
    reqBuilder
      .withMethod('POST')
      .withPath(_getCallResetPasswordFunctionRoute());
    reqBuilder.withDocument({
      [ActionFields.EMAIL]: email,
      [ActionFields.PASSWORD]: password,
      [ActionFields.ARGS]: args
    });
    await this.requestClient.doRequest(reqBuilder.build());
  }

  String _getRegisterWithEmailRoute() {
    return _getExtensionRoute('register');
  }

  String _getConfirmUserRoute() {
    return _getExtensionRoute('confirm');
  }

  String _getResendConfirmationEmailRoute() {
    return _getExtensionRoute('confirm/send');
  }

  String _getResetPasswordRoute() {
    return _getExtensionRoute('reset');
  }

  String _getSendResetPasswordEmailRoute() {
    return _getExtensionRoute('reset/send');
  }

  String _getCallResetPasswordFunctionRoute() {
    return _getExtensionRoute('reset/call');
  }

  String _getExtensionRoute(String path) {
    return '$baseRoute/$path';
  }
}