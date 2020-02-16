import 'package:stitch_core/stitch_core.dart' show CoreStitchServiceClient;
import './core_remote_mongo_client.dart' show CoreRemoteMongoClient;
import './core_remote_mongo_database.dart' show CoreRemoteMongoDatabase;
import './core_remote_mongo_database_impl.dart' show CoreRemoteMongoDatabaseImpl;

class CoreRemoteMongoClientImpl implements CoreRemoteMongoClient {
  final CoreStitchServiceClient service;
  
  CoreRemoteMongoClientImpl(this.service);

  /// Gets a `CoreRemoteMongoDatabase` instance for the given database name.
  ///
  /// - parameter name: the name of the database to retrieve
  CoreRemoteMongoDatabase db(String name) {
    return CoreRemoteMongoDatabaseImpl(name, this.service);
  }
}