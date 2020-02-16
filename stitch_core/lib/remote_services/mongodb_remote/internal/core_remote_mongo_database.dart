
import 'package:stitch_core/stitch_core.dart' show Codec;
import './core_remote_mongo_collection.dart' show CoreRemoteMongoCollection;

abstract class CoreRemoteMongoDatabase {
  /// Gets the name of the database.
  ///
  /// @return the database name
  final String name;

  CoreRemoteMongoDatabase(this.name);

  /// Gets a collection.
  ///
  /// @param name the name of the collection to return
  /// @return the collection
  CoreRemoteMongoCollection<T> collection<T>(String name, [Codec<T> codec]);
}