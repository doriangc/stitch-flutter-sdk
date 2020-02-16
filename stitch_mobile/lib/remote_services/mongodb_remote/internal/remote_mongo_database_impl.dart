import 'package:stitch_core/stitch_core.dart' show Codec, CoreRemoteMongoDatabase;
import './remote_mongo_collection_impl.dart' show RemoteMongoCollectionImpl;

class RemoteMongoDatabaseImpl {
  final String name;

  final CoreRemoteMongoDatabase _proxy;

  RemoteMongoDatabaseImpl(CoreRemoteMongoDatabase proxy) :
    _proxy = proxy,
    name = proxy.name;

  /// Gets a collection.
  RemoteMongoCollectionImpl<T> collection<T>(
    String name,
    [Codec<T> codec]
  ) {
    return RemoteMongoCollectionImpl<T>(
      _proxy.collection(name, codec)
    );
  }
}
