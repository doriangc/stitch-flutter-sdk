import 'package:stitch_core/stitch_core.dart' show CoreRemoteMongoClient;
import '../remote_mongo_client.dart' show RemoteMongoClient;
import '../remote_mongo_database.dart' show RemoteMongoDatabase;
import './remote_mongo_database_impl.dart' show RemoteMongoDatabaseImpl;

class RemoteMongoClientImpl implements RemoteMongoClient {
  final CoreRemoteMongoClient _proxy;

  RemoteMongoClientImpl(CoreRemoteMongoClient proxy) : _proxy = proxy;

  /// Gets a [RemoteMongoDatabase] instance for the given database name.
  RemoteMongoDatabaseImpl db(String name) {
    return RemoteMongoDatabaseImpl(_proxy.db(name));
  }
}
