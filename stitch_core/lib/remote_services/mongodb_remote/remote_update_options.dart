/// Options to use when executing an `updateOne` or `updateMany` command on a 
/// [[RemoteMongoCollection]].
abstract class RemoteUpdateOptions {
  /// When true, creates a new document if no document matches the query. 
  bool upsert;
}
