import 'package:stitch_core/stitch_core.dart' show Codec;
import './remote_mongo_collection.dart' show RemoteMongoCollection;

/// RemoteMongoDatabase provides access to a MongoDB database.
/// 
/// It is instantiated by [[RemoteMongoClient]].
///
/// Once instantiated, it can be used to access a [[RemoteMongoCollection]]
/// for reading and writing data.
abstract class RemoteMongoDatabase {
  /// Gets the name of the database.
  final String name;

  RemoteMongoDatabase(this.name);

  /// Gets a collection.
  RemoteMongoCollection<T> collection<T>(String name, [Codec<T> codec]);
}
