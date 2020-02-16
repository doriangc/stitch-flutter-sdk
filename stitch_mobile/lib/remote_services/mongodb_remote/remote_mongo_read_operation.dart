import 'package:stitch_core/stitch_core.dart' show CoreRemoteMongoReadOperation;
import './remote_mongo_cursor.dart' show RemoteMongoCursor;

/// Represents a `find` or `aggregate` operation against a [[RemoteMongoCollection]].
/// 
/// The methods in this class execute the operation and retrieve the results,
/// either as an [[iterator]] or all in one array with [[toArray]].
/// 
class RemoteMongoReadOperation<T> {
  final CoreRemoteMongoReadOperation<T> _proxy;
  RemoteMongoReadOperation(
    CoreRemoteMongoReadOperation<T> proxy
  ) :
  _proxy = proxy;

  // Executes the operation and returns the first document in the result.
  Future<T> first() {
    return _proxy.first();
  }

  /// Executes the operation and returns the result as an array.
  Future<List<T>> toArray() {
    return _proxy.toArray();
  }

  /// Executes the operation and returns the result as an array.
  /// @deprecated Use toArray instead
  Future<List<T>> asArray(){
    return this.toArray();
  }

  /// Executes the operation and returns a cursor to its resulting documents.
  Future<RemoteMongoCursor<T>> iterator() {
    return _proxy.iterator().then((res) => new RemoteMongoCursor(res));
  }
}
