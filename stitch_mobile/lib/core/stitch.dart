import 'package:stitch_core/stitch_core.dart' show StitchAppClientConfiguration, StitchAppClientConfigurationBuilder;
import './internal/common/local_storage.dart' show LocalStorage;
import './internal/net/browser_fetch_transport.dart' show BrowserFetchTransport;
import 'stitch_app_client.dart' show StitchAppClient;
import './internal/stitch_app_client_impl.dart' show StitchAppClientImpl;


const DEFAULT_BASE_URL = 'https://stitch.mongodb.com';

// class StitchAppClientConfiguration {}

/// Singleton class with static utility functions for initializing a [StitchAppClient].
///
/// Typically, the [Stitch.initializeDefaultAppClient] method is all you need
/// to instantiate the client:
/// ```
/// const client = Stitch.initializeDefaultAppClient('your-stitch-app-id')
/// ```
///
/// For custom configurations, see [Stitch.initializeAppClient] and [StitchAppClientConfiguration].
Map<String, StitchAppClientImpl> appClients = {};

abstract class Stitch {
  static String defaultClientAppId;
  static String localAppVersion;
  static String localAppName;

  /// Retrieves the default [StitchAppClient] associated with the application.
  static StitchAppClient get defaultAppClient {
    if (Stitch.defaultClientAppId == null) {
      throw 'default app client has not yet been initialized/set';
    }
    return appClients[Stitch.defaultClientAppId];
  }

  /// Retrieves the [StitchAppClient] associated with the specified clientAppId.
  static StitchAppClient getAppClient(String clientAppId) {
    if (appClients[clientAppId] == null) {
      throw 'client for app $clientAppId has not yet been initialized';
    }
    return appClients[clientAppId];
  }

  /// Returns whether or not a [StitchAppClient] has been initialized for the
  /// specified clientAppId.
  static bool hasAppClient(String clientAppId) {
    return appClients[clientAppId] != null;
  }

  /// Initializes the default [StitchAppClient] associated with the specified
  /// clientAppId.
  static StitchAppClient initializeDefaultAppClient(String clientAppId) {
    if (clientAppId == null || clientAppId == '') {
      throw 'clientAppId must be set to a non-empty string';
    }
    if (Stitch.defaultClientAppId != null) {
      throw 'default app can only be set once; currently set to ${Stitch.defaultClientAppId}';
    }

    StitchAppClient client = Stitch.initializeAppClient(clientAppId);
    Stitch.defaultClientAppId = clientAppId;
    return client;
  }

  /// Initializes a new, non-default [StitchAppClient] associated with the 
  /// application.
  static StitchAppClient initializeAppClient(String clientAppId, [StitchAppClientConfiguration config]) {
    if (config == null) {
      config = StitchAppClientConfigurationBuilder().build();
    }

    if (clientAppId == null || clientAppId == '') {
      throw 'clientAppId must be set to a non-empty string';
    }
    if (appClients[clientAppId] != null) {
      throw 'client for app $clientAppId has already been initialized';
    }
    
    // builder will be passed into [StitchAppClientImpl]
    StitchAppClientConfigurationBuilder builder = config.builder();

    // apply defaults to builder
    if (builder.storage == null) {
      builder.withStorage(LocalStorage(clientAppId));
    }
    if (builder.transport == null) {
      // Use the EventSource-streaming compatible transport if the browser
      // supports it, otherwise use a vanilla FetchTransport that will fail on
      // attempting to open a stream.
      // if (window["EventSource"]) {
        // builder.withTransport(new BrowserFetchStreamTransport());  
      // } else {
        builder.withTransport(BrowserFetchTransport());
      // }
    }
    if (builder.baseUrl == null || builder.baseUrl == '') {
      builder.withBaseUrl(DEFAULT_BASE_URL);
    }
    if (builder.localAppName == null || builder.localAppName == '') {
      builder.withLocalAppName(Stitch.localAppName);
    }
    if (builder.localAppVersion == null || builder.localAppVersion == '') {
      builder.withLocalAppVersion(Stitch.localAppVersion);
    }

    StitchAppClientImpl client = StitchAppClientImpl(clientAppId, builder.build());
    appClients[clientAppId] = client;
    return client;
  }
}
