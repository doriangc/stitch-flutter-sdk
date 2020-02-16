/// The result of an `updateOne` or `updateMany` operation a [[RemoteMongoCollection]].
class RemoteUpdateResult {
  /// The number of documents that matched the filter.
  final int matchedCount;

  /// The number of documents matched by the query.
  final int modifiedCount;

  /// The identifier of the inserted document if an upsert took place.
  ///
  /// See [[RemoteUpdateOptions.upsert]].
  final dynamic upsertedId;

  RemoteUpdateResult({this.matchedCount, this.modifiedCount, this.upsertedId});
}
