library stitch_core;

/**
 * Copyright 2018-present MongoDB, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// export BSON from "bson";

export './auth/internal/auth_event.dart' show ActiveUserChanged, 
  AuthEvent, 
  AuthEventKind, 
  ListenerRegistered, 
  UserAdded,
  UserLinked,
  UserLoggedIn,
  UserLoggedOut,
  UserRemoved;
export 'auth/internal/auth_info.dart' show AuthInfo;
export './auth/internal/auth_info.dart' show AuthInfo;
export './auth/internal/core_stitch_auth.dart' show CoreStitchAuth;
export './auth/internal/core_stitch_user.dart' show CoreStitchUser;
export './auth/internal/core_stitch_user_impl.dart' show CoreStitchUserImpl;
export './auth/internal/device_fields.dart' show DeviceFields;
export './auth/internal/models/api_stitch_user_identity.dart' show ApiStitchUserIdentity;
export './auth/internal/stitch_auth_request_client.dart' show StitchAuthRequestClient;
export './auth/internal/stitch_auth_routes.dart' show StitchAuthRoutes;
export './auth/internal/stitch_user_factory.dart';
export './auth/internal/stitch_user_profile_impl.dart' show StitchUserProfileImpl;
export './auth/providers/anonymous/anonymous_auth_provider.dart' show AnonymousAuthProvider;
export './auth/providers/anonymous/anonymous_credential.dart' show AnonymousCredential;
export './auth/providers/custom/custom_auth_provider.dart' show CustomAuthProvider;
export './auth/providers/custom/custom_credential.dart' show CustomCredential;
export './auth/providers/facebook/facebook_auth_provider.dart' show FacebookAuthProvider;
export './auth/providers/facebook/facebook_credential.dart' show FacebookCredential;
export './auth/providers/function/function_auth_provider.dart' show FunctionAuthProvider;
export './auth/providers/function/function_credential.dart' show FunctionCredential;
export './auth/providers/google/google_auth_provider.dart' show GoogleAuthProvider;
export './auth/providers/google/google_credential.dart' show GoogleCredential;
export './auth/providers/internal/stitch_auth_response_credential.dart' show StitchAuthResponseCredential;
export './auth/providers/serverapikey/server_api_key_auth_provider.dart' show ServerApiKeyAuthProvider;
export './auth/providers/serverapikey/server_api_key_credential.dart' show ServerApiKeyCredential;
// TODO: implement below functionality
// export CoreUserApiKeyAuthProviderClient from "./auth/providers/userapikey/CoreUserApiKeyAuthProviderClient";
// export UserApiKey from "./auth/providers/userapikey/models/UserApiKey";
// export UserApiKeyAuthProvider from "./auth/providers/userapikey/UserApiKeyAuthProvider";
// export UserApiKeyCredential from "./auth/providers/userapikey/UserApiKeyCredential";
export './auth/providers/userpass/core_user_password_auth_provider_client.dart' show CoreUserPasswordAuthProviderClient;
export './auth/providers/userpass/user_password_auth_provider.dart' show UserPasswordAuthProvider;
export './auth/providers/userpass/user_password_credential.dart' show UserPasswordCredential;
export './auth/stitch_credential.dart' show StitchCredential;
export './auth/stitch_user_identity.dart' show StitchUserIdentity;
export './auth/stitch_user_profile.dart' show StitchUserProfile;
export './auth/user_type.dart' show UserType;
// export Assertions from "./internal/common/Assertions"
export './internal/common/base64.dart' show customBase64Decode, customBase64Encode;
export './internal/common/codec.dart' show Codec, Decoder, Encoder;
export './internal/common/stitch_error_utils.dart' show handleRequestError;
export './internal/common/storage.dart' show MemoryStorage, Storage;
export './internal/core_stitch_app_client.dart' show CoreStitchAppClient;
export './internal/net/base_event_stream.dart' show BaseEventStream;
export './internal/net/basic_request.dart' show BasicRequest;
export './internal/net/content_types.dart' show ContentTypes;
export './internal/net/event.dart' show Event;
export './internal/net/event_listener.dart' show EventListener;
export './internal/net/event_stream.dart' show EventStream;
export './internal/net/headers.dart' show Headers;
// export Method from "./internal/net/Method";
export './internal/net/response.dart' show Response;
// export StitchAppAuthRoutes from "./internal/net/StitchAppAuthRoutes";
// export StitchAppRequestClient from "./internal/net/StitchAppRequestClient";
// export StitchAppRoutes from "./internal/net/StitchAppRoutes";
export './internal/net/stitch_app_auth_routes.dart' show StitchAppAuthRoutes;
export './internal/net/stitch_app_request_client.dart' show StitchAppRequestClient;
export './internal/net/stitch_app_routes.dart' show StitchAppRoutes;
export './internal/net/stitch_auth_request.dart' show StitchAuthRequest;
export './internal/net/stitch_event.dart' show StitchEvent;
export './internal/net/stitch_request_client.dart' show StitchRequestClient;
export './internal/net/base_stitch_request_client.dart' show BaseStitchRequestClient;
export './internal/net/transport.dart' show Transport;
export './services/internal/auth_rebind_event.dart' show AuthRebindEvent;
export './services/internal/core_stitch_service_client.dart' show CoreStitchServiceClient;
export './services/internal/core_stitch_service_client_impl.dart' show CoreStitchServiceClientImpl;
export './services/internal/rebind_event.dart' show RebindEvent;
export './services/internal/stitch_service_routes.dart' show StitchServiceRoutes;
export './stitch_app_client_configuration.dart' show StitchAppClientConfiguration, StitchAppClientConfigurationBuilder;
export './stitch_app_client_info.dart' show StitchAppClientInfo;
// export StitchClientError from "./StitchClientError";
// export { StitchClientErrorCode } from "./StitchClientErrorCode";
// export StitchError from "./StitchError";
// export StitchRequestError from "./StitchRequestError";
// export { StitchRequestErrorCode } from "./StitchRequestErrorCode";
// export StitchServiceError from "./StitchServiceError";
// export { StitchServiceErrorCode } from "./StitchServiceErrorCode";
export './stream.dart' show Stream;
export './stream_listener.dart' show StreamListener;

export './remote_services/mongodb_remote/mongodb_remote.dart';

// export {
//   BSON,
//   AuthInfo,
//   StitchAuthResponseCredential,
//   AnonymousAuthProvider,
//   AnonymousCredential,
//   ApiStitchUserIdentity,
//   CustomAuthProvider,
//   CustomCredential,
//   FacebookAuthProvider,
//   FacebookCredential,
//   FunctionAuthProvider,
//   FunctionCredential,
//   GoogleAuthProvider,
//   GoogleCredential,
//   ServerApiKeyAuthProvider,
//   ServerApiKeyCredential,
//   UserApiKeyAuthProvider,
//   UserApiKey,
//   UserApiKeyCredential,
//   Codec,
//   Decoder,
//   Encoder,
//   StitchError,
//   StitchClientError,
//   StitchClientErrorCode,
//   CoreUserApiKeyAuthProviderClient,
//   UserPasswordAuthProvider,
//   UserPasswordCredential,
//   CoreUserPassAuthProviderClient,
//   CoreStitchAppClient,
//   CoreStitchAuth,
//   CoreStitchServiceClient,
//   CoreStitchUser,
//   CoreStitchUserImpl,
//   DeviceFields,
//   BasicRequest,
//   ContentTypes,
//   Event,
//   EventListener,
//   EventStream,
//   BaseEventStream,
//   StitchEvent,
//   Headers,
//   Stream,
//   StreamListener,
//   StitchAppClientInfo,
//   StitchAppClientConfiguration,
//   StitchAppRequestClient,
//   StitchAppRoutes,
//   StitchAuthRequest,
//   StitchAuthRequestClient,
//   StitchAuthRoutes,
//   StitchCredential,
//   StitchRequestClient,
//   StitchRequestError,
//   StitchRequestErrorCode,
//   StitchServiceRoutes,
//   StitchServiceError,
//   StitchServiceErrorCode,
//   StitchUserFactory,
//   StitchUserProfile,
//   StitchUserProfileImpl,
//   CoreStitchServiceClientImpl,
//   StitchUserIdentity,
//   StitchAppAuthRoutes,
//   Storage,
//   Method,
//   Response,
//   MemoryStorage,
//   handleRequestError,
//   Transport,
//   UserType,
//   Assertions,
//   AuthEvent,
//   AuthEventKind,
//   ActiveUserChanged,
//   ListenerRegistered,
//   RebindEvent,
//   AuthRebindEvent,
//   UserAdded,
//   UserLinked,
//   UserLoggedIn,
//   UserLoggedOut,
//   UserRemoved,
//   base64Decode,
//   base64Encode,
//   utf8Slice
// };
