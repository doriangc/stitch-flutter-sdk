library stitch_mobile;

export 'package:stitch_core/stitch_core.dart' show
  AnonymousAuthProvider,
  AnonymousCredential,
  // BSON,
  Codec,
  CustomAuthProvider,
  CustomCredential,
  Decoder,
  Encoder,
  FacebookAuthProvider,
  FacebookCredential,
  FunctionAuthProvider,
  FunctionCredential,
  GoogleAuthProvider,
  GoogleCredential,
  MemoryStorage,
  ServerApiKeyAuthProvider,
  ServerApiKeyCredential,
  StitchAppClientConfiguration,
  StitchAppClientInfo,
  // StitchClientError,
  // StitchClientErrorCode,
  StitchCredential,
  // StitchRequestError,
  // StitchRequestErrorCode,
  // StitchServiceError,
  // StitchServiceErrorCode,
  StitchUserIdentity,
  StitchUserProfile,
  Storage,
  Stream,
  StreamListener,
  Transport,
  // UserApiKey,
  // UserApiKeyAuthProvider,
  // UserApiKeyCredential,
  UserPasswordAuthProvider,
  UserPasswordCredential,
  UserType;

// export 'package:stitch_core/remote_services/mongodb_remote/mongodb_remote.dart' show CoreRemoteMongoClient;

// export './core/auth/providers/'

// export FacebookRedirectCredential from "./core/auth/providers/facebook/FacebookRedirectCredential";
// export GoogleRedirectCredential from "./core/auth/providers/google/GoogleRedirectCredential";
// export { UserApiKeyAuthProviderClient } from "./core/auth/providers/userapikey/UserApiKeyAuthProviderClient";
export './core/auth/providers/userpassword/user_password_auth_provider_client.dart' show UserPasswordAuthProviderClient;
export 'core/auth/stitch_auth.dart' show StitchAuth;
export './core/auth/stitch_auth_listener.dart' show StitchAuthListener;
export './core/auth/stitch_user.dart' show StitchUser;
export './core/internal/net/browser_fetch_transport.dart' show BrowserFetchTransport;
export './core/stitch.dart' show Stitch;
export './core/stitch_app_client.dart' show StitchAppClient;
export './services/internal/named_service_client_factory.dart' show NamedServiceClientFactory;
export './services/stitch_service_client.dart' show StitchServiceClient;

export './remote_services/mongodb_remote/mongodb_remote.dart';