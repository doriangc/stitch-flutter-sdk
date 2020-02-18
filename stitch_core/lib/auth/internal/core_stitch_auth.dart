import 'dart:convert';

import 'package:stitch_core/stitch_exception.dart';

import '../../internal/common/bson.dart' show eJsonDecode;
import '../../internal/common/codec.dart' show Decoder;
import '../../internal/common/storage.dart' show Storage;
import '../../internal/net/event_stream.dart' show EventStream;
import '../../internal/net/headers.dart' show Headers;
import '../../internal/net/response.dart' show Response;
import '../../internal/net/stitch_auth_doc_request.dart' show StitchAuthDocRequest;
import '../../internal/net/stitch_auth_request.dart' show StitchAuthRequest, StitchAuthRequestBuilder;
import '../../internal/net/stitch_doc_request.dart' show StitchDocRequestBuilder;
import '../../internal/net/stitch_request.dart' show StitchRequest;
import '../../stitch_core.dart';
import '../../stream.dart' show Stream;
import './core_stitch_user_impl.dart' show CoreStitchUserImpl;
import '../providers/anonymous/anonymous_auth_provider.dart' show AnonymousAuthProvider;
import '../providers/internal/stitch_auth_response_credential.dart' show StitchAuthResponseCredential;
import '../stitch_credential.dart' show StitchCredential;
import './access_token_refresher.dart' show AccessTokenRefresher;
import './auth_event.dart' show AuthEvent, UserLoggedOut, UserRemoved, UserAdded, UserLinked, UserLoggedIn, ActiveUserChanged;
import './auth_info.dart' show AuthInfo;
import './core_stitch_user.dart' show CoreStitchUser;
import './jwt.dart' show JWT;
import './models/api_auth_info.dart' show ApiAuthInfo;
import './models/api_core_user_profile.dart' show ApiCoreUserProfile;
import './models/store_auth_info.dart' show readActiveUserFromStorage, readCurrentUsersFromStorage, writeActiveUserAuthInfoToStorage, writeAllUsersAuthInfoToStorage;
import './stitch_auth_request_client.dart' show StitchAuthRequestClient;
import './stitch_auth_routes.dart' show StitchAuthRoutes;
import './stitch_user_factory.dart' show StitchUserFactory;
import './stitch_user_profile_impl.dart' show StitchUserProfileImpl;
import 'stitch_auth_request_client.dart' show StitchAuthRequestClient;

const OPTIONS = "options";
const DEVICE = "device";

/// The core class that holds and manages Stitch user authentication state. This class is meant to be inherited.
// Pass in TStitchUser: The underlying user type for this `CoreStitchAuth`, which must conform to `CoreStitchUser`.
abstract class CoreStitchAuth<TStitchUser extends CoreStitchUser> implements StitchAuthRequestClient {
  /// The authentication information of the active user, as represented by an 
  /// `AuthInfo` object.
  AuthInfo get authInfo => activeUserAuthInfo;

  /// Whether or not a user is currently logged in.
  bool get isLoggedIn => (currentUser != null && currentUser.isLoggedIn);

  /// The currently authenticated user as a `TStitchUser`, or `null` if no user is currently authenticated.
  TStitchUser get user => currentUser;

  bool get hasDeviceId => (
    activeUserAuthInfo.deviceId != null &&
    activeUserAuthInfo.deviceId != '' &&
    activeUserAuthInfo.deviceId != '000000000000000000000000'
  );

  /// Returns the currently authenticated user's device id, or `undefined` is no user is currently authenticated, or if the
  /// device id does not exist.
  String get deviceId {
    if (!hasDeviceId) {
      return null;
    }

    return activeUserAuthInfo.deviceId;
  }

  /// The `StitchRequestClient` used by the `CoreStitchAuth` to make requests to the Stitch server.
  final StitchAppRequestClient requestClient;
  
  /// The `StitchAuthRoutes` object representing the authentication API routes
  /// of the Stitch server for the current
  /// app.
  final StitchAuthRoutes authRoutes;

  /// Should return an `StitchUserFactory` object, capable of constructing users of the `TStitchUser` type.
  StitchUserFactory<TStitchUser> userFactory;
  
  /// A field that should return an object containing information about the current device.
  Map<String, String> deviceInfo;

  AuthInfo activeUserAuthInfo;

  /// The `Storage` object indicating where authentication information should be persisted.
  final Storage storage;
  
  /// A `TStitchUser` object that represents the currently authenticated active 
  /// user, or `undefined` if there is no active user.
  TStitchUser currentUser;

  /// An ordered dictionary of all of the cached users associated with this 
  /// application keyed by Stitch user ID, some of whom may be logged in.
  Map<String, AuthInfo> allUsersAuthInfo;

  AccessTokenRefresher<TStitchUser> accessTokenRefresher;
  final bool useTokenRefresher;

  CoreStitchAuth(
    this.requestClient,
    this.authRoutes,
    this.storage,
    [this.useTokenRefresher = true]
  );

  // Temporary workaround TODO: Fix
  Future<void> initProcess() async {
    Map<String, AuthInfo> allUsersAuthInfo;
    try {
      allUsersAuthInfo = await readCurrentUsersFromStorage(storage);
    } catch(e) {
      // throw new StitchClientError(
        // StitchClientErrorCode.CouldNotLoadPersistedAuthInfo
      // );
      throw StitchException('CouldNotLoadPersistedAuthInfo');
    }
    this.allUsersAuthInfo = allUsersAuthInfo;

    // AuthInfo activeUserAuthInfo;
    try {
      activeUserAuthInfo = await readActiveUserFromStorage(storage);
    } catch (e) {
      throw StitchException(
        'Could Not Load Persisted Auth Info!'
      );
    }

    activeUserAuthInfo = activeUserAuthInfo == null ? AuthInfo.empty() : activeUserAuthInfo;

    if (activeUserAuthInfo.hasUser) {
      currentUser = _prepUser(activeUserAuthInfo);
    }

    if (useTokenRefresher) {
      accessTokenRefresher = AccessTokenRefresher(this);
      accessTokenRefresher.run();
    }
  }

  List<TStitchUser> listUsers() {
    List<TStitchUser> list = [];
  
    allUsersAuthInfo.forEach( (String key, AuthInfo authInfo) {
      list.add(_prepUser(authInfo));
    });

    return list;
  }

  /// Performs an authenticated request to the Stitch server, using the current 
  /// authentication state of the active user, or the AuthInfo provided if one 
  /// is provided. Will throw when when the active user or provided user auth 
  /// info is not currently logged in.
  Future<Response> doAuthenticatedRequest(
    StitchAuthRequest stitchReq,
    [AuthInfo authInfo]
  ) async {
    try {
      return await requestClient.doRequest(prepareAuthRequest(stitchReq, authInfo ?? this.activeUserAuthInfo));
    } catch(err) {
      throw StitchException(err);
    }
  }

  /// Performs an authenticated request to the Stitch server with a JSON body, and decodes the extended JSON response into
  /// an object. Uses the current authentication state, and will throw when the `CoreStitchAuth` is not currently authenticated.
  Future<T> doAuthenticatedRequestWithDecoder<T>(
    StitchAuthRequest stitchReq,
    [Decoder<T> decoder]
  ) async {
    var response = await doAuthenticatedRequest(stitchReq);

    var obj = eJsonDecode(json.decode(response.body));

    if (decoder != null) {
      return decoder.decode(obj);
    }

    return obj;
  }

  Future<EventStream> openAuthenticatedEventStream(
    StitchAuthRequest stitchReq,
    [bool open = true]
  ) async {
    if (!isLoggedIn) {
      // throw new StitchClientError(StitchClientErrorCode.MustAuthenticateFirst);
      throw StitchException('MustAuthenticateFirst');
    }

    String authToken = stitchReq.useRefreshToken ? activeUserAuthInfo.refreshToken : activeUserAuthInfo.accessToken;

    return await requestClient.doStreamRequest(
      stitchReq.builder()
      .withPath('${stitchReq.path}&stitch_at=${authToken}')
      .build(),
      open: open,
      retryRequest: () => openAuthenticatedEventStream(stitchReq, false)).catchError((err) {
      this._handleAuthFailureForEventStream(stitchReq, open: open);
    });
  }

  Future<Stream<T>> openAuthenticatedStreamWithDecoder<T>(
    StitchAuthRequest stitchReq,
    Decoder<T> decoder
  ) async {
    EventStream eventStream = await openAuthenticatedEventStream(stitchReq);
    return Stream<T>(eventStream, decoder);
  }

  /// Attempts to refresh the current access token.
  Future<void> refreshAccessToken() async {
    StitchAuthRequestBuilder reqBuilder = StitchAuthRequestBuilder()
      .withRefreshToken()
      .withPath(authRoutes.sessionRoute)
      .withMethod('POST');

    var response = await doAuthenticatedRequest(reqBuilder.build());

    try {
      ApiAuthInfo partialInfo = ApiAuthInfo.fromJSON(json.decode(response.body));
      activeUserAuthInfo = activeUserAuthInfo.merge(partialInfo);
      if (partialInfo.accessToken != null && user is CoreStitchUserImpl) {
        Map<String, dynamic> userData = JWT.fromEncoded(partialInfo.accessToken).userData;
        (this.user as CoreStitchUserImpl).customData = userData == null ? {} : userData;
      }
    } catch (err) {
      throw new StitchException(err);
    }

    try {
      writeActiveUserAuthInfoToStorage(activeUserAuthInfo, this.storage);

      this.allUsersAuthInfo[this.activeUserAuthInfo.userId] = this.activeUserAuthInfo;
      writeAllUsersAuthInfoToStorage(this.allUsersAuthInfo, this.storage);
    } catch (err) {
      // throw new StitchClientError(
        // StitchClientErrorCode.CouldNotPersistAuthInfo
      // );
      throw StitchException('CouldNotPersistAuthInfo');
    }
  }

  /// Changes the active user of this [[CoreStitchAuth]] to be the user with
  /// the specified id. The user must have logged in on this client at least 
  /// once, and the user must not have been removed from the list of users
  /// with a call to [[removeUser]]. Use [[listUsers]] to get a list of the 
  /// users that can be switched to.
  /// 
  /// @param userId The id of the user to switch to
  /// @throws [[StitchClientError.UserNotFound]] if the user was not found,
  ///         [[StitchClientError.UserNotLoggedIn]] if the user is logged out.
  TStitchUser switchToUserWithId(String userId) {
    AuthInfo authInfo = this.allUsersAuthInfo[userId];
    if (authInfo == null) {
      // throw new StitchClientError(StitchClientErrorCode.UserNotFound);
      throw StitchException('UserNotFound');
    }
    if (!authInfo.isLoggedIn) {
      // throw new StitchClientError(
      //   StitchClientErrorCode.UserNotLoggedIn
      // );
      throw StitchException('UserNotLoggedIn');
    }

    // Update the previous activeUserAuthInfo's lastAuthActivity if there was 
    // A previous active user.
    if (this.activeUserAuthInfo.hasUser) {
      this.allUsersAuthInfo[this.activeUserAuthInfo.userId] =  this.activeUserAuthInfo.withNewAuthActivityTime();
    }
    var newAuthInfo = authInfo.withNewAuthActivityTime();
    this.allUsersAuthInfo[userId] = newAuthInfo;


    // Persist auth info storage before actually setting auth state so that
    // If the persist call throws, we are not in an inconsistent state
    // With storage
    writeActiveUserAuthInfoToStorage(newAuthInfo, this.storage);

    // Set the active user auth info and active user to the user with ID as 
    // Specified in the list of all users.
    this.activeUserAuthInfo = newAuthInfo;

    TStitchUser previousUser = this.currentUser;
    this.currentUser = _prepUser(newAuthInfo);

    // Dispatch an ActiveUserChangedEvent indicating to listeners that the 
    // Active user was switched from one user to another.
    this.onAuthEvent(); // Legacy event dispatch
    this.dispatchAuthEvent(ActiveUserChanged<TStitchUser>(
      currentActiveUser: this.currentUser,
      previousActiveUser: previousUser
    ));

    return this.currentUser;
  }

  /// Authenticates the `CoreStitchAuth` using the provided `StitchCredential`. Blocks the current thread until the
  /// request is completed.
  Future<TStitchUser> loginWithCredentialInternal(
    StitchCredential credential
  ) async {
    if (credential is StitchAuthResponseCredential) {
      TStitchUser user = await _processLogin(credential, credential.authInfo, credential.asLink);

      this.dispatchAuthEvent(UserLoggedIn(
        // kind: AuthEventKind.UserLoggedIn,
        user
      ));

      return user;
    }

    /// if we are logging in with a credential that reuses existing sessions
    /// (e.g. the anonymous credential), check to see if any users are already
    /// logged in with that credential.
    if (credential.providerCapabilities.reusesExistingSession) {
      this.allUsersAuthInfo.forEach((userId, authInfo) {
        if (authInfo.loggedInProviderType == credential.providerType) {
          if (authInfo.isLoggedIn) {
            return this.switchToUserWithId(userId);
          }
          if (authInfo.userId != null) {
            this.removeUserWithIdInternal(authInfo.userId);
          }
        }
      });      
    }

    return this._doLogin(credential, false);
  }

  /// Links the currently logged in user with a new identity represented by the 
  /// provided `StitchCredential`.
  Future<TStitchUser> linkUserWithCredentialInternal(
    CoreStitchUser user,
    StitchCredential credential
  ) {
    if (this.currentUser != null && user.id != this.currentUser.id) {
      // return Promise.reject(
      //   new StitchClientError(StitchClientErrorCode.UserNoLongerValid)
      // );
      throw StitchException('UserNoLongerValid');
    }

    return _doLogin(credential, true);
  }

  /// Logs out the current user, and clears authentication state from this `CoreStitchAuth` as well as underlying
  /// storage. If the logout request fails, this method will
  /// still attempt to clear local authentication state. This method will only throw if clearing authentication state
  /// fails.
  Future<void> logoutInternal() async {
    if (this.isLoggedIn && this.currentUser != null) {
      return await this.logoutUserWithIdInternal(this.currentUser.id);
    }
  }

  Future<void> logoutUserWithIdInternal(String userId) async {
    AuthInfo authInfo = this.allUsersAuthInfo[userId];
    
    if (authInfo == null) {
      // return Promise.reject(
      //   new StitchClientError(StitchClientErrorCode.UserNotFound)
      // );
      throw StitchException('UserNotFound');
    }

    if (!authInfo.isLoggedIn) {
      return;
    }

    Function clearAuthBlock = () {
      _clearUserAuthTokens(authInfo.userId);

      /// Note: the UserLoggedOut event is not dispatched here. It is dispatched
      /// in the [[clearUserAuthTokens]] method, where there is more context 
      /// about the user being logged out and whether that user was the active
      /// user.

      // If the user was anonymous, delete the user, since you can't log back
      // In to an anonymous user after they have logged out.
      if (authInfo.loggedInProviderType == AnonymousAuthProvider.TYPE) {
        this.removeUserWithIdInternal(authInfo.userId);
      }
    };

    try {
      await _doLogout(authInfo);
      clearAuthBlock();
    } catch (err) {
      clearAuthBlock();
    }
  }

  /// Removes the active user.
  Future<void> removeUserInternal() async {
    if (!this.isLoggedIn || this.currentUser == null) {
      return;
    }

    return this.removeUserWithIdInternal(this.currentUser.id);
  }

  /// Removes the user with the specified ID from the list of all users.
  /// @param userId the id of the user to remove
  Future<void> removeUserWithIdInternal(String userId) async {
    AuthInfo authInfo = this.allUsersAuthInfo[userId];

    if (authInfo == null) {
      // return Promise.reject(
      //   new StitchClientError(StitchClientErrorCode.UserNotFound)
      // );
      throw StitchException('UserNotFound');
    }

    Function removeBlock = () {
      _clearUserAuthTokens(authInfo.userId);
      this.allUsersAuthInfo.remove(userId);
      writeAllUsersAuthInfoToStorage(this.allUsersAuthInfo, this.storage);

      TStitchUser removedUser = _prepUser(authInfo.loggedOut());

      // Dispatch an event indicating that a user was removed.
      this.onAuthEvent();
      this.dispatchAuthEvent(UserRemoved(
        removedUser
      ));
    };
    
    if (authInfo.isLoggedIn) {
      try {
        await _doLogout(authInfo);
        removeBlock();
      } catch(err) {
        removeBlock();
      }
    }

    // If the user being removed isn't logged in, just clear that user's auth
    // And update the list of all users.
    removeBlock();
    return;
  }

  /// Close stops any background processes maintained by auth. This
  /// should be called when auth services are no longer needed.
  close() {
    if (this.accessTokenRefresher != null) {
      this.accessTokenRefresher.stop();
    }
  }

  /// Abstract declaration of the method to be implemented by platform-specific
  /// SDKs to dispatch events to the deprecated "onAuthEvent" method in the
  /// StitchAuthListener.
  onAuthEvent();

  /// Abstract declaration of the method to be implemented by platform-specific
  /// SDKs to dispatch events to the new event methods in the StitchAuthListener.
  dispatchAuthEvent(AuthEvent<TStitchUser> event);

  /// Prepares an authenticated Stitch request by attaching the `CoreStitchAuth`'s current access or refresh token
  /// (depending on the type of request) to the request's `"Authorization"` header.
  StitchRequest prepareAuthRequest(
    StitchAuthRequest stitchReq,
    AuthInfo authInfo
  ) {
    if (!authInfo.isLoggedIn) {
      // throw new StitchClientError(StitchClientErrorCode.MustAuthenticateFirst);
      throw StitchException('MustAuthenticateFirst');
    }

    StitchAuthRequestBuilder newReq = stitchReq.builder();
    var newHeaders = newReq.headers ?? {}; // This is not a copy

    if (stitchReq.useRefreshToken != null && stitchReq.useRefreshToken) {
      newHeaders[Headers.AUTHORIZATION] = Headers.getAuthorizationBearer(
        authInfo.refreshToken
      );
    } else {
      newHeaders[Headers.AUTHORIZATION] = Headers.getAuthorizationBearer(
        authInfo.accessToken
      );
    }
    newReq.withHeaders(newHeaders);
    return newReq.build();
  }

  Future<EventStream> _handleAuthFailureForEventStream(
    StitchAuthRequest req,
    {open = true}
  ) async {
    // Using a refresh token implies we cannot refresh anything, 
    // So clear auth and notify
    if (req.useRefreshToken || !req.shouldRefreshOnFailure) {
      _clearActiveUserAuth();
      throw 'Unknown Error';
    }

    await this.tryRefreshAccessToken(req.startedAt);
    return this.openAuthenticatedEventStream(
        req.builder().withShouldRefreshOnFailure(false).build(),
        open
    );
  }

  /// Checks the `StitchServiceError` object provided in the `forError` parameter, and if it's an error indicating an invalid
  /// Stitch session, it will handle the error by attempting to refresh the access token if it hasn't been attempted
  /// already. If the error is not a Stitch error, or the error is a Stitch error not related to an invalid session,
  /// it will be re-thrown.
  Future<Response> _handleAuthFailure(
    StitchAuthRequest req
  ) async {

    // Using a refresh token implies we cannot refresh anything, 
    // So clear auth and notify
    if (req.useRefreshToken || !req.shouldRefreshOnFailure) {
      _clearActiveUserAuth();
      throw 'Unknown Error';
    }

    await this.tryRefreshAccessToken(req.startedAt);
    this.doAuthenticatedRequest(
      req.builder().withShouldRefreshOnFailure(false).build()
    );
  }

  /// Checks if the current access token is expired or going to expire soon, and refreshes the access token if
  /// necessary
  Future<void> tryRefreshAccessToken(num reqStartedAt) async {
    /*
     * Use this critical section to create a queue of pending outbound requests
     * that should wait on the result of doing a token refresh or logout. This will
     * prevent too many refreshes happening one after the other.
     */
    if (!this.isLoggedIn) {
      throw StitchException('LoggedOutDuringRequest');
    }

    try {
      JWT jwt = JWT.fromEncoded(this.activeUserAuthInfo.accessToken);
      if (jwt.issuedAt >= reqStartedAt) {
        return;
      }
    } catch (e) {
      // Swallow (gulp...)
    }

    // Retry
    return this.refreshAccessToken();
  }

  TStitchUser _prepUser(AuthInfo authInfo) {
    return this.userFactory.makeUser(
      authInfo.userId,
      authInfo.loggedInProviderType,
      authInfo.loggedInProviderName,
      authInfo.isLoggedIn,
      authInfo.lastAuthActivity,
      authInfo.userProfile
    );
  }

  /// Attaches authentication options to the BSON document passed in as the `authBody` parameter. Necessary for the
  /// the login request.
  _attachAuthOptions(Map<String, dynamic> authBody) {
    Map<String, dynamic> options = {};
    options[DEVICE] = this.deviceInfo;
    authBody[OPTIONS] = options;
  }

  /// Performs the logic of logging in this `CoreStitchAuth` as a new user with the provided credential. Can also
  /// perform a user link if the `asLinkRequest` parameter is true.
  Future<TStitchUser> _doLogin(
    StitchCredential credential,
    bool asLinkRequest
  ) async {
    TStitchUser previousActiveUser = this.currentUser;
    var response = await _doLoginRequest(credential, asLinkRequest);

    TStitchUser user = await _processLoginResponse(credential, response, asLinkRequest);
    this.onAuthEvent(); // Legacy event dispatch

    // Dispatch the appropriate auth events
    // For the type of login that occured.
    if (asLinkRequest) {
      this.dispatchAuthEvent(UserLinked(
        user
      ));
    } else {
      // This triggers an event for the user logging in, as well as the 
      // Active user changing.
      this.dispatchAuthEvent(UserLoggedIn(
        user
      ));
      this.dispatchAuthEvent(ActiveUserChanged(
        currentActiveUser: user,
        previousActiveUser: previousActiveUser
      ));
    }
        
    return user;
  }

  /// Performs the login request against the Stitch server. If `asLinkRequest` is true, a link request is performed
  /// instead.
  Future<Response> _doLoginRequest(
    StitchCredential credential,
    bool asLinkRequest
  ) async {
    StitchDocRequestBuilder reqBuilder = StitchDocRequestBuilder();
    reqBuilder.withMethod('POST');

    if (asLinkRequest) {
      reqBuilder.withPath(
        this.authRoutes.getAuthProviderLinkRoute(credential.providerName)
      );
    } else {
      reqBuilder.withPath(
        this.authRoutes.getAuthProviderLoginRoute(credential.providerName)
      );
    }

    Map<String, dynamic> material =  {};
    
    // TODO: optimize
    credential.material.forEach((key, value) { // naive clone into 'dynamic' type
      material[key] = value;
    });


    _attachAuthOptions(material);
    reqBuilder.withDocument(material);

    if (!asLinkRequest) {
      return await this.requestClient.doRequest(reqBuilder.build());
    }
    StitchAuthDocRequest linkRequest = StitchAuthDocRequest(
      reqBuilder.build(),
      reqBuilder.document
    );

    return await this.doAuthenticatedRequest(linkRequest);
  }

  /// Processes the authentication info from the login/link request, setting the authentication state, and
  /// requesting the user profile in a separate request.
  Future<TStitchUser> _processLogin(
    StitchCredential credential,
    AuthInfo newAuthInfo,
    bool asLinkRequest
  ) async {

    // Preserve old auth info in case of profile request failure
    AuthInfo oldActiveUserInfo = this.activeUserAuthInfo;
    TStitchUser oldActiveUser = this.currentUser;

    newAuthInfo = this.activeUserAuthInfo.merge(
      new AuthInfo(
        newAuthInfo.userId,
        newAuthInfo.deviceId,
        newAuthInfo.accessToken,
        newAuthInfo.refreshToken,
        credential.providerType,
        credential.providerName,
        null,
        null
      )
    );

    // Provisionally set so we can make a profile request
    this.activeUserAuthInfo = newAuthInfo;

    this.currentUser = this.userFactory.makeUser(
      this.activeUserAuthInfo.userId,
      credential.providerType,
      credential.providerName,
      this.activeUserAuthInfo.isLoggedIn,
      DateTime.now(),
      null,
      JWT.fromEncoded(newAuthInfo.accessToken).userData
    );
    
    try {
      var profile = await _doGetUserProfile();
      // Update the old user's auth activity if there was one
      if (oldActiveUserInfo.hasUser) {
        this.allUsersAuthInfo[oldActiveUserInfo.userId] = oldActiveUserInfo.withNewAuthActivityTime();
      }

      // Finally set the info and user
      newAuthInfo = newAuthInfo.merge(
        new AuthInfo(
          newAuthInfo.userId,
          newAuthInfo.deviceId,
          newAuthInfo.accessToken,
          newAuthInfo.refreshToken,
          credential.providerType,
          credential.providerName,
          DateTime.now(),
          profile
        )
      );

      bool newUserAdded = !this.allUsersAuthInfo.containsKey(newAuthInfo.userId);

      try {
        writeActiveUserAuthInfoToStorage(newAuthInfo, this.storage);

        // this replaces any old info that may have 
        // existed for this user if this was a link request, or if this 
        // user already existed in the list of all users
        this.allUsersAuthInfo[newAuthInfo.userId] = newAuthInfo;

        writeAllUsersAuthInfoToStorage(this.allUsersAuthInfo, this.storage);
      } catch (err) {
        // Back out of setting authInfo with this new user
        this.activeUserAuthInfo = oldActiveUserInfo;
        this.currentUser = oldActiveUser;
        
        // Delete the new partial auth info from the list of all users if
        // The new auth info is not the same user
        if (newAuthInfo.userId != oldActiveUserInfo.userId && newAuthInfo.userId != null) {
          this.allUsersAuthInfo.remove(newAuthInfo.userId);
        }
        
        // throw new StitchClientError(
        //   StitchClientErrorCode.CouldNotPersistAuthInfo
        // );
        throw StitchException('CouldNotPersistAuthInfo');
      }
      
      // Set the active user info to the new 
      // Auth info and new user with profile
      this.activeUserAuthInfo = newAuthInfo;
      this.currentUser = this.userFactory.makeUser(
        this.activeUserAuthInfo.userId,
        credential.providerType,
        credential.providerName,
        this.activeUserAuthInfo.isLoggedIn,
        this.activeUserAuthInfo.lastAuthActivity,
        profile,
        JWT.fromEncoded(newAuthInfo.accessToken).userData
      );

      // Dispatch a UserAdded event if this is the first time this user is 
      // Being added to the list of users on the device.
      if (newUserAdded) {
        this.onAuthEvent(); // Legacy event dispatch

        this.dispatchAuthEvent(UserAdded(
          this.currentUser,
        ));
      }

      return this.currentUser;
  
    } catch (err) {
      // Propagate persistence errors
      // if (err is StitchClientError) {
      //   throw err;
      // }

      // If this was a link request or there was an active user logged in,
      // back out of setting authInfo and reset any created user. This
      //  will keep the currently logged in user logged in if the profile
      //  request failed, and in this particular edge case the user is
      /// linked, but they are logged in with their older credentials.
      if (asLinkRequest || oldActiveUserInfo.hasUser) {
        AuthInfo linkedAuthInfo = this.activeUserAuthInfo;
        this.activeUserAuthInfo = oldActiveUserInfo;
        this.currentUser = oldActiveUser; 

        // To prevent the case where this user gets removed when logged out 
        // in the future because the original provider type was anonymous, 
        // make sure the auth info reflects the new logged in provider type 
        if (asLinkRequest) {
          this.activeUserAuthInfo = this.activeUserAuthInfo.withAuthProvider(
            linkedAuthInfo.loggedInProviderType,
            linkedAuthInfo.loggedInProviderName
          );
        }
      } else { // Otherwise this was a normal login request, so log the user out
        _clearActiveUserAuth();
      }

      throw err;
    }
  }

  /// Processes the response of the login/link request, setting the authentication state if appropriate, and
  /// requesting the user profile in a separate request.
  Future<TStitchUser> _processLoginResponse(
    StitchCredential credential,
    Response response,
    bool asLinkRequest
  ) {
    try {
      if (response == null) {
        // throw new StitchServiceError(
        //   `the login response could not be processed for credential: ${credential};` +
        //     `response was undefined`
        // );
        throw StitchException('the login response could not be processed for credential: $credential \n response was null');
      }
      if (response.body == null || response.body == '') {
        throw new StitchException(
          'response with status code ${response.statusCode} has empty body'
        );
      }
      return _processLogin(
        credential,
        ApiAuthInfo.fromJSON(json.decode(response.body)),
        asLinkRequest
      );
    } catch (err) {
      // throw new StitchRequestError(err, StitchRequestErrorCode.DECODING_ERROR);
      throw StitchException('DECODINGERROR');
    }
  }

  ///Performs a request against the Stitch server to get the currently authenticated user's profile.
  Future<StitchUserProfileImpl> _doGetUserProfile() async {
    StitchAuthRequestBuilder reqBuilder = StitchAuthRequestBuilder();
    reqBuilder.withMethod('GET').withPath(this.authRoutes.profileRoute);

    try {
      Response response = await this.doAuthenticatedRequest(reqBuilder.build());

      return ApiCoreUserProfile.fromJSON(json.decode(response.body));
    } catch(err) {
      // if (err is StitchError) {
      //   throw err;
      // } else {
      //   throw new StitchRequestError(
      //     err,
      //     StitchRequestErrorCode.DECODING_ERROR
      //   );
      // }
      throw err;
    }
  }

  /// Performs a logout request against the Stitch server.
  Future<void> _doLogout(AuthInfo authInfo) async {
    StitchAuthRequestBuilder reqBuilder = StitchAuthRequestBuilder();
    reqBuilder
      .withRefreshToken()
      .withPath(this.authRoutes.sessionRoute)
      .withMethod('DELETE');
    await this.doAuthenticatedRequest(reqBuilder.build(), authInfo);
  }

  /// Clears the `CoreStitchAuth`'s authentication state, as well as associated authentication state in underlying
  /// storage.
  _clearActiveUserAuth() {
    if (!this.isLoggedIn) {
      return;
    }

    _clearUserAuthTokens(this.activeUserAuthInfo.userId);
  }

  _clearUserAuthTokens(String userId) {
    AuthInfo unclearedAuthInfo = allUsersAuthInfo[userId];
    if (unclearedAuthInfo == null) {
       /// This doesn't necessarily mean there's an error. we could be in a 
       /// provisional state where the profile request failed and we're just
       /// trying to log out the active user.
      if (activeUserAuthInfo.userId != userId) {
        // Only throw if this ID is not the active user either
        // throw new StitchClientError(StitchClientErrorCode.UserNotFound);  
        throw StitchException('UserNotFound');
      }
    } else if (!unclearedAuthInfo.isLoggedIn) {
      // If the auth info's tokens are already cleared, 
      // There's no need to clear them again
      return;
    }

    try {
      TStitchUser loggedOutUser;

      if (unclearedAuthInfo != null) {
        AuthInfo loggedOutAuthInfo = unclearedAuthInfo.loggedOut();
        allUsersAuthInfo[userId] = loggedOutAuthInfo;
        writeAllUsersAuthInfoToStorage(allUsersAuthInfo, storage);

        loggedOutUser = userFactory.makeUser(
          loggedOutAuthInfo.userId,
          loggedOutAuthInfo.loggedInProviderType,
          loggedOutAuthInfo.loggedInProviderName,
          loggedOutAuthInfo.isLoggedIn,
          loggedOutAuthInfo.lastAuthActivity,
          loggedOutAuthInfo.userProfile,
        );
      }
      
      // If the auth info we're clearing is also the active user's auth info, 
      // Clear the active user's auth as well
      bool wasActiveUser = false;
      if (this.activeUserAuthInfo.hasUser && activeUserAuthInfo.userId == userId) {
        wasActiveUser = true;
        activeUserAuthInfo = activeUserAuthInfo.withClearedUser();
        currentUser = null;

        writeActiveUserAuthInfoToStorage(activeUserAuthInfo, storage);
      }

      /// If a user was actually logged out, and it wasn't just clearing auth 
      /// tokens from a provisional state, dispatch a logout event to any 
      /// listeners, and additionally dispatch an ActiveUserChanged event if
      /// the user being logged out was the active user.
      if (loggedOutUser != null) {
        onAuthEvent(); // Legacy event dispatch

        dispatchAuthEvent(UserLoggedOut(
          loggedOutUser,
        ));

        if (wasActiveUser) {
          this.dispatchAuthEvent(ActiveUserChanged(
            currentActiveUser: null,
            previousActiveUser: loggedOutUser
          ));
        }
      }
    } catch (err) {
      // throw new StitchClientError(
      //   StitchClientErrorCode.CouldNotPersistAuthInfo
      // );
      throw StitchException('CouldNotPersistAuthInfo');
    }
  }
}