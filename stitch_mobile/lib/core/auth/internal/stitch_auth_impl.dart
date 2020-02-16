import 'package:stitch_core/stitch_core.dart' show ActiveUserChanged, AuthEvent, AuthEventKind, AuthInfo, CoreStitchAuth, CoreStitchUser, DeviceFields, ListenerRegistered, StitchAppClientInfo, StitchAppRequestClient, StitchCredential, Storage, UserAdded, UserLinked, UserLoggedIn, UserLoggedOut, UserRemoved;

import '../providers/internal/auth_provider_client_factory.dart' show AuthProviderClientFactory;
import '../stitch_auth.dart' show StitchAuth;
import '../stitch_auth_listener.dart' show StitchAuthListener;
import '../stitch_user.dart' show StitchUser;
import './stitch_browser_app_auth_routes.dart' show StitchBrowserAppAuthRoutes;
import './stitch_user_factory_impl.dart' show StitchUserFactoryImpl;

class StitchAuthImpl extends CoreStitchAuth<StitchUser> implements StitchAuth {
  static dynamic injectedFetch;
  List<StitchAuthListener> listeners = [];
  List<StitchAuthListener> synchronousListeners  = [];

  final StitchAppClientInfo _appInfo;


  /// Construct a new StitchAuth implementation
  ///
  /// @param requestClient StitchRequestClient that does request
  /// @param browserAuthRoutes pathnames to call for browser routes
  /// @param authStorage internal storage
  /// @param appInfo info about the current stitch app
  /// @param jsdomWindow window interface to interact with JSDOM window
  StitchAuthImpl(
    StitchAppRequestClient requestClient,
    StitchBrowserAppAuthRoutes browserAuthRoutes,
    Storage authStorage,
    StitchAppClientInfo appInfo
  ) : _appInfo = appInfo,
      super(requestClient, browserAuthRoutes, authStorage);

  get userFactory => StitchUserFactoryImpl(this);

  ClientT getProviderClient<ClientT>(
    dynamic clientFactory, // | AuthProviderClientFactory<ClientT> | NamedAuthProviderClientFactory<ClientT>,
    [String providerName]
  ) {
    if (isAuthProviderClientFactory(clientFactory)) {
      return clientFactory.getClient(this, this.requestClient, this.authRoutes);
    } else {
      return clientFactory.getNamedClient(
        providerName,
        this.requestClient,
        this.authRoutes
      );
    }
  }

  Future<StitchUser> loginWithCredential(
    StitchCredential credential
  ) {
    return super.loginWithCredentialInternal(credential);
  }

  Future<StitchUser> linkWithCredential(
    CoreStitchUser user,
    StitchCredential credential
  ) {
    return super.linkUserWithCredentialInternal(user, credential);
  }

  Future<void> logout() {
    return super.logoutInternal();
  }

  Future<void> logoutUserWithId(String userId) {
    return super.logoutUserWithIdInternal(userId);
  }

  Future<void> removeUser() {
    return super.removeUserInternal();
  }

  Future<void> removeUserWithId(String userId) {
    return super.removeUserWithIdInternal(userId);
  }

  get deviceInfo {
    Map<String, String> info = {};
    if (this.hasDeviceId) {
      info[DeviceFields.DEVICE_ID] = this.deviceId;
    }
    if (_appInfo.localAppName != null) {
      info[DeviceFields.APP_ID] = _appInfo.localAppName;
    }
    if (_appInfo.localAppVersion != null) {
      info[DeviceFields.APP_VERSION] = _appInfo.localAppVersion;
    }

    // TODO: fix hardcoded values
    info[DeviceFields.PLATFORM] = "flutter";
    info[DeviceFields.PLATFORM_VERSION] = "0.0.1";
    info[DeviceFields.SDK_VERSION] = '4.8.0';

    return info;
  }

  addAuthListener(StitchAuthListener listener) {
    this.listeners.add(listener);

    // Trigger the ListenerRegistered event in case some event happens and
    // This caller would miss out on this event other wise.

    // Dispatch a legacy deprecated auth event
    this.onAuthEvent(listener);

    // Dispatch a new style auth event
    this.dispatchAuthEvent(ListenerRegistered());
  }

  addSynchronousAuthListener(StitchAuthListener listener) {
    this.listeners.add(listener);

    // Trigger the ListenerRegistered event in case some event happens and
    // This caller would miss out on this event other wise.

    // Dispatch a legacy deprecated auth event
    this.onAuthEvent(listener);

    // Dispatch a new style auth event
    this.dispatchAuthEvent(ListenerRegistered());
  }

  removeAuthListener(StitchAuthListener listener) {
    this.listeners.remove(listener);
  }
 
  /// Dispatch method for the deprecated auth listener method onAuthEvent.
  onAuthEvent([StitchAuthListener listener]) {
    if (listener != null) {
      () async {
        if (listener.onAuthEvent != null) {
          listener.onAuthEvent(this);  
        }
      }();
    } else {
      this.listeners.forEach( (one) {
        this.onAuthEvent(one);
      });
    }
  }

  /// Dispatch method for the new auth listener methods.
  /// @param event the discriminated union representing the auth event
  dispatchAuthEvent(AuthEvent<StitchUser> event) {
    switch(event.kind) {
      case AuthEventKind.ActiveUserChanged:
        this.dispatchBlockToListeners((StitchAuthListener listener) {
          if (listener.onActiveUserChanged != null) {
            listener.onActiveUserChanged(
              this,
              (event as ActiveUserChanged).currentActiveUser,
              (event as ActiveUserChanged).previousActiveUser
            );  
          }
        });
        break;
      case AuthEventKind.ListenerRegistered:
        this.dispatchBlockToListeners((StitchAuthListener listener) {
          if (listener.onListenerRegistered != null) {
            listener.onListenerRegistered(this);  
          }
        });
        break;
      case AuthEventKind.UserAdded:
        this.dispatchBlockToListeners((StitchAuthListener listener) {
          if (listener.onUserAdded != null) {
            listener.onUserAdded(this, (event as UserAdded).addedUser);  
          }
        });
        break;
      case AuthEventKind.UserLinked:
        this.dispatchBlockToListeners((StitchAuthListener listener) {
          if (listener.onUserLinked != null) {
            listener.onUserLinked(this, (event as UserLinked).linkedUser);
          }
        });
        break;
      case AuthEventKind.UserLoggedIn:
        this.dispatchBlockToListeners((StitchAuthListener listener) {
          if (listener.onUserLoggedIn != null) {
            listener.onUserLoggedIn(
              this,
              (event as UserLoggedIn).loggedInUser
            );
          }
        });
        break;
      case AuthEventKind.UserLoggedOut:
        this.dispatchBlockToListeners((StitchAuthListener listener) {
          if (listener.onUserLoggedOut != null) {
            listener.onUserLoggedOut(
              this, 
              (event as UserLoggedOut).loggedOutUser
            );  
          }
        });
        break;
      case AuthEventKind.UserRemoved:
        this.dispatchBlockToListeners((StitchAuthListener listener) {
          if (listener.onUserRemoved != null) {
            listener.onUserRemoved(this, (event as UserRemoved).removedUser);
          }
        });
        break;
      default:
        // Compiler trick to force this switch to be exhaustive. if the above
        // switch statement doesn't check all AuthEventKinds, event will not
        // be of type never.
    
        // return this.assertNever(event);
        throw 'AUTH ERROR!'; // TODO: Add more descriptive error
    }
  }

  Future<void> refreshCustomData() {
    return refreshAccessToken();
  }
  
  /// Utility function used to force the compiler to enforce an exhaustive 
  /// switch statment in dispatchAuthEvent at compile-time.
  /// @see https://www.typescriptlang.org/docs/handbook/advanced-types.html
  // private assertNever(x: never): never {
  //   throw new Error("unexpected object: " + x);
  // }

  /// Dispatches the provided block to all auth listeners, including the 
  /// synchronous and asynchronous ones.
  dispatchBlockToListeners(void Function(StitchAuthListener) block) {
    // Dispatch to all synchronous listeners
    this.synchronousListeners.forEach(block);

    // Dispatch to all asynchronous listeners
    this.listeners.forEach( (listener) {
      var _ = () async {
        block(listener);
      }();
    });
  }

  AuthInfo unmarshallUserAuth(data) {
    List<String> parts = data.split('\$');
    if (parts.length != 4) {
      throw 'invalid user auth data provided while marshalling user authentication data: $data';
    }

    // List [accessToken, refreshToken, userId, deviceId] = parts;
    String accessToken = parts[0];
    String refreshToken = parts[1];
    String userId = parts[2];
    String deviceId = parts[3];

    return new AuthInfo(userId, deviceId, accessToken, refreshToken);
  }
  
  bool isAuthProviderClientFactory<ClientT>(
    dynamic clientFactory // AuthProviderClientFactory<ClientT> NamedAuthProviderClientFactory<ClientT>
  ) {
    return (
      (clientFactory as AuthProviderClientFactory<ClientT>).getClient != null
    );
  }
}