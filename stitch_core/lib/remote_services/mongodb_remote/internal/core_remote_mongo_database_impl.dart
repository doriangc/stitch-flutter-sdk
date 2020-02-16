
import 'package:stitch_core/stitch_core.dart' show Codec, CoreStitchServiceClient;
import './core_remote_mongo_collection.dart' show CoreRemoteMongoCollection;
import './core_remote_mongo_collection_impl.dart' show CoreRemoteMongoCollectionImpl;
import './core_remote_mongo_database.dart' show CoreRemoteMongoDatabase;

class CoreRemoteMongoDatabaseImpl implements CoreRemoteMongoDatabase {
  final String name;
  final CoreStitchServiceClient service;

  CoreRemoteMongoDatabaseImpl(
    this.name, this.service
  );

  /// Gets a collection.
  ///
  /// - parameter name: the name of the collection to return
  // - returns: the collection
  CoreRemoteMongoCollection<T> collection<T>(
    String name,
    [Codec<T> codec]
  ) {
    return CoreRemoteMongoCollectionImpl(
      name,
      this.name,
      this.service,
      codec
    );
  }
}
