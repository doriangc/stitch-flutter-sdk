import 'package:stitch_core/stitch_core.dart' show ActiveUserChanged, AuthRebindEvent, CoreStitchAppClient, CoreStitchServiceClient, CoreStitchServiceClientImpl, RebindEvent, StitchAppClientConfiguration, StitchAppClientInfo, StitchAppRequestClient;

import '../../services/internal/service_client_factory.dart' show ServiceClientFactory;
import '../../services/internal/stitch_service_client_impl.dart' show StitchServiceClientImpl;
import '../../services/stitch_service_client.dart' show StitchServiceClient;
import '../auth/internal/stitch_auth_impl.dart' show StitchAuthImpl;
import '../auth/internal/stitch_browser_app_routes.dart' show StitchBrowserAppRoutes;
import '../auth/stitch_auth.dart' show StitchAuth;
import '../auth/stitch_auth_listener.dart' show StitchAuthListener;
import '../auth/stitch_user.dart' show StitchUser;
import '../stitch_app_client.dart' show StitchAppClient;

class StitchAppClientImpl extends StitchAppClient implements StitchAuthListener {
  StitchAuthImpl auth;

  CoreStitchAppClient _coreClient;
  final StitchAppClientInfo _info;
  final StitchBrowserAppRoutes _routes;

  List<CoreStitchServiceClient> _serviceClients;

  StitchAppClientImpl(
    String clientAppId,
    StitchAppClientConfiguration config
  ) :
    _info = StitchAppClientInfo(
      clientAppId,
      config.dataDirectory,
      config.localAppName,
      config.localAppVersion
    ),
    _routes = StitchBrowserAppRoutes(
      clientAppId,
    ) {
      StitchAppRequestClient requestClient = StitchAppRequestClient(
      clientAppId,
      config.baseUrl,
      config.transport
    );
    auth = StitchAuthImpl(
      requestClient,
      _routes.authRoutes,
      config.storage,
      _info
    );
    _coreClient = new CoreStitchAppClient(auth, _routes);
    _serviceClients = [];
    auth.addSynchronousAuthListener(this);
  }

  T getServiceClient<T>(
    dynamic clientFactory,
    [String serviceName]
  ) {
    if (isServiceClientFactory(clientFactory)) {
      CoreStitchServiceClientImpl serviceClient = CoreStitchServiceClientImpl(
        auth, _routes.serviceRoutes, ''
      );
      _bindServiceClient(serviceClient);
      return clientFactory.getClient(serviceClient, _info);
    } else {
      CoreStitchServiceClientImpl serviceClient = CoreStitchServiceClientImpl(
        auth,
        _routes.serviceRoutes,
        serviceName
      );
      _bindServiceClient(serviceClient);
      return clientFactory.getNamedClient(
        serviceClient,
        _info
      );
    }
  }

  StitchServiceClient getGeneralServiceClient(String serviceName) {
    CoreStitchServiceClientImpl serviceClient = CoreStitchServiceClientImpl(
      auth,
      _routes.serviceRoutes,
      serviceName
    );
    _bindServiceClient(serviceClient);
    return StitchServiceClientImpl(
      serviceClient
    );
  }

  Future<dynamic> callFunction(String name, List<dynamic> args) {
    return _coreClient.callFunction(name, args);
  }

  // note: this is the only rebind event we care about for Dart. if we add 
  // services in the future, or update existing services in such a way that 
  // they'll need to rebind on other types of events, those handlers should be
  // added to this file.
  onActiveUserChanged(
    StitchAuth _, 
    [StitchUser currentActiveUser, 
    StitchUser previousActiveUser
    ]
  ) {
    _onRebindEvent(AuthRebindEvent(ActiveUserChanged(
      currentActiveUser: currentActiveUser,
      previousActiveUser: previousActiveUser
    )));
  }

  close() {
    auth.close();
  }

  _bindServiceClient(CoreStitchServiceClient coreStitchServiceClient) {
    _serviceClients.add(coreStitchServiceClient);
  }

  _onRebindEvent(RebindEvent rebindEvent) {
    _serviceClients.forEach((serviceClient) {
      serviceClient.onRebindEvent(rebindEvent);
    });
  }

  @override
  T getServiceClientByFactory<T>(ServiceClientFactory<T> serviceFactory) {
    // TODO: implement getServiceClientByFactory
    return null;
  }

  @override
  onAuthEvent(StitchAuth auth) {
    // TODO: implement onAuthEvent
    return null;
  }

  @override
  onListenerRegistered(StitchAuth auth) {
    // TODO: implement onListenerRegistered
    return null;
  }

  @override
  onUserAdded(StitchAuth auth, StitchUser addedUser) {
    // TODO: implement onUserAdded
    return null;
  }

  @override
  onUserLinked(StitchAuth auth, StitchUser linkedUser) {
    // TODO: implement onUserLinked
    return null;
  }

  @override
  onUserLoggedIn(StitchAuth auth, StitchUser loggedInUser) {
    // TODO: implement onUserLoggedIn
    return null;
  }

  @override
  onUserLoggedOut(StitchAuth auth, StitchUser loggedOutUser) {
    // TODO: implement onUserLoggedOut
    return null;
  }

  @override
  onUserRemoved(StitchAuth auth, StitchUser removedUser) {
    // TODO: implement onUserRemoved
    return null;
  }
}

bool isServiceClientFactory<T>(
  dynamic clientFactory
) {
  return (clientFactory is ServiceClientFactory<T>);
}