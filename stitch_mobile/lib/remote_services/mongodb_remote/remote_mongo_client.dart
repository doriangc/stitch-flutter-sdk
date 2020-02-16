import 'package:stitch_mobile/stitch_mobile.dart' show NamedServiceClientFactory;

import 'package:stitch_core/stitch_core.dart' show CoreStitchServiceClient, StitchAppClientInfo, CoreRemoteMongoClientImpl;

import './internal/remote_mongo_client_impl.dart' show RemoteMongoClientImpl;
import './internal/remote_mongo_database_impl.dart' show RemoteMongoDatabaseImpl;

/// The RemoteMongoClient can be used to get database and collection objects
/// for interacting with MongoDB data via the Stitch MongoDB service.
///
/// Service clients are created with [[StitchAppClient.getServiceClient]] by passing
/// [[RemoteMongoClient.factory]] and the "Stitch Service Name" found under _Clusters_
/// in the [Stitch control panel](https://stitch.mongodb.com)
/// ("mongodb-atlas" by default).
///
/// Once the RemoteMongoClient is instantiated, you can use the [[db]] method to access
/// a [[RemoteMongoDatabase]]. A RemoteMongoDatabase will then provide access to
/// a [[RemoteMongoCollection]], where you can read and write data.
///
/// Note: The client needs to log in (at least anonymously) to use the database.
/// See [[StitchAuth]].
abstract class RemoteMongoClient {
  /// Gets a [[RemoteMongoDatabase]] instance for the given database name.
  RemoteMongoDatabaseImpl db(String name);

  // /// TODO: Fix dart keyword user
  // get factory => RemoteMongoClientFactory();
}

class RemoteMongoClientFactory implements NamedServiceClientFactory<RemoteMongoClient> {
  RemoteMongoClient getNamedClient(
    CoreStitchServiceClient service,
    StitchAppClientInfo client
  ) {
    return RemoteMongoClientImpl(CoreRemoteMongoClientImpl(service));
  }
}

class RemoteMongoClientBuilder {
  final NamedServiceClientFactory<RemoteMongoClient> clientFactory = RemoteMongoClientFactory();
}
