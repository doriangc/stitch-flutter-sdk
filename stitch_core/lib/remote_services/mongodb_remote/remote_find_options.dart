
/// Options to use when executing a `find` command on a 
/// [[RemoteMongoCollection]].
class RemoteFindOptions {
  /// The maximum number of documents to return. 
  final int limit;

  /// Limits the fields to return for all matching documents. See 
  /// [Tutorial: Project Fields to Return from Query](https://docs.mongodb.com/manual/tutorial/project-fields-from-query-results/).
  final dynamic projection;

  /// The order in which to return matching documents.
  final dynamic sort;

  RemoteFindOptions({this.limit, this.projection, this.sort});  
}
