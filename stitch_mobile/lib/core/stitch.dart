import 'package:stitch_core/stitch_core.dart' show StitchAppClientConfiguration, StitchAppClientConfigurationBuilder;
import 'package:stitch_mobile/core/internal/net/browser_fetch_stream_transport.dart';
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
    if (defaultClientAppId == null) {
      throw 'default app client has not yet been initialized/set';
    }
    return appClients[defaultClientAppId];
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
  static Future<StitchAppClient> initializeDefaultAppClient(String clientAppId) async {
    if (clientAppId == null || clientAppId == '') {
      throw 'clientAppId must be set to a non-empty string';
    }
    if (defaultClientAppId != null) {
      throw 'default app can only be set once; currently set to $defaultClientAppId';
    }

    StitchAppClient client = await initializeAppClient(clientAppId);
    defaultClientAppId = clientAppId;
    return client;
  }

  /// Initializes a new, non-default [StitchAppClient] associated with the 
  /// application.
  static Future<StitchAppClient> initializeAppClient(String clientAppId, [StitchAppClientConfiguration config]) async {
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

    print('Preparing to link Storage');
    // apply defaults to builder
    if (builder.storage == null) {
      builder.withStorage(LocalStorage(clientAppId));
    }
    print('Done linking storage');
    if (builder.transport == null) {
      // Use the EventSource-streaming compatible transport if the browser
      // supports it, otherwise use a vanilla FetchTransport that will fail on
      // attempting to open a stream.
      // if (window["EventSource"]) {
        // builder.withTransport(new BrowserFetchStreamTransport());  
      // } else {
        builder.withTransport(BrowserFetchTransport());
        // builder.withTransport(BrowserFetchStreamTransport());
      // }
    }
    if (builder.baseUrl == null || builder.baseUrl == '') {
      builder.withBaseUrl(DEFAULT_BASE_URL);
    }
    if (builder.localAppName == null || builder.localAppName == '') {
      builder.withLocalAppName(localAppName);
    }
    if (builder.localAppVersion == null || builder.localAppVersion == '') {
      builder.withLocalAppVersion(localAppVersion);
    }

    StitchAppClientImpl client = StitchAppClientImpl(clientAppId, builder.build());
    await client.auth.initProcess();

    appClients[clientAppId] = client;
    return client;
  }
}
