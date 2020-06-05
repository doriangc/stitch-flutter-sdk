import 'package:stitch_core/stitch_core.dart' show Codec, Stream, ChangeEvent, CompactChangeEvent, RemoteCountOptions, 
RemoteDeleteResult, RemoteFindOneAndModifyOptions, RemoteFindOptions, RemoteInsertManyResult, RemoteInsertOneResult,
RemoteUpdateOptions, RemoteUpdateResult;
import './internal/remote_mongo_collection_impl.dart' show RemoteMongoCollectionImpl;

import './remote_mongo_read_operation.dart' show RemoteMongoReadOperation;

/// The RemoteMongoCollection is the interface to a MongoDB database's
/// collection via Stitch, allowing read and write.
///
/// It is retrieved from a [[RemoteMongoDatabase]].
///
/// The read operations are [[find]], [[count]] and [[aggregate]].
///
/// The write operations are [[insertOne]], [[insertMany]], 
/// [[updateOne]], [[updateMany]], [[deleteOne]], and [[deleteMany]].
///
/// It is also possible to [[watch]] documents in the collection for
/// changes.
///
/// If you are already familiar with MongoDB drivers, it is important
/// to understand that the RemoteMongoCollection only provides access
/// to the operations available in Stitch. For a list of unsupported
/// aggregation stages, see 
/// [Unsupported Aggregation Stages](https://docs.mongodb.com/stitch/mongodb/actions/collection.aggregate/#unsupported-aggregation-stages).
///
/// A user will also need to be logged in (at least anonymously) before you can read from
/// or write to the collection. See [[StitchAuth]].
abstract class RemoteMongoCollection<DocumentT> {
  /// Gets the namespace of this collection.
  final String namespace;

  RemoteMongoCollection(this.namespace);

  /// Create a new RemoteMongoCollection instance with a different default class to cast any
  /// documents returned from the database into.
  RemoteMongoCollectionImpl<U> withCollectionType<U>(Codec<U> codec);

  /// Counts the number of documents in the collection.
  Future<int> count([Map<String, dynamic> query, RemoteCountOptions options]);

  /// Finds all documents in the collection that match the given query.
  /// 
  /// An empty query (`{}`) will match all documents.
  ///
  RemoteMongoReadOperation<DocumentT> find([
    Map<String, dynamic> query,
    RemoteFindOptions options
  ]);

  /// Finds one document in the collection that matches the given query.
  /// 
  /// An empty query (`{}`) will match all documents.
  Future<DocumentT> findOne(
    Map<String, dynamic> query,
    RemoteFindOptions options
  );

  /// Finds one document in the collection that matches the given query and performs the 
  /// given update on that document. (An empty query {} will match all documents)
  Future<DocumentT> findOneAndUpdate(
    Map<String, dynamic> query,
    Map<String, dynamic> update, 
    [RemoteFindOneAndModifyOptions options]
  );

  /// Finds one document in the collection that matches the given query and replaces that document 
  /// with the given replacement. (An empty query {} will match all documents)
  Future<DocumentT> findOneAndReplace(
    Map<String, dynamic> query,
    Map<String, dynamic> replacement, 
    [RemoteFindOneAndModifyOptions options]
  );

  /// Finds one document in the collection that matches the given query and 
  /// deletes that document. (An empty query {} will match all documents)
  Future<DocumentT> findOneAndDelete(
    Map<String, dynamic> query,
    [RemoteFindOneAndModifyOptions options]
  );

  /// Aggregates documents according to the specified aggregation pipeline.
  ///
  /// Stitch supports a subset of the available aggregation stages in MongoDB.
  /// See 
  /// [Unsupported Aggregation Stages](https://docs.mongodb.com/stitch/mongodb/actions/collection.aggregate/#unsupported-aggregation-stages).
  RemoteMongoReadOperation<DocumentT> aggregate(List<Map<String, dynamic>> pipeline);

  /// Inserts the provided document. If the document is missing an identifier, the client should
  /// generate one.
  Future<RemoteInsertOneResult> insertOne(DocumentT document);

  /// Inserts one or more documents.
  Future<RemoteInsertManyResult> insertMany(List<DocumentT> documents);

  /// Removes at most one document from the collection that matches the given filter.
  /// If no documents match, the collection is not modified.
  Future<RemoteDeleteResult> deleteOne(Map<String, dynamic> query);

  /// Removes all documents from the collection that match the given query filter.  If no documents
  /// match, the collection is not modified.
  Future<RemoteDeleteResult> deleteMany(Map<String, dynamic> query);

  /// Update a single document in the collection according to the specified arguments.
  Future<RemoteUpdateResult> updateOne(
    Map<String, dynamic> query,
    Map<String, dynamic> update,
    [RemoteUpdateOptions updateOptions]
  );

  /// Update all documents in the collection according to the specified arguments.
  Future<RemoteUpdateResult> updateMany(
    Map<String, dynamic> query,
    Map<String, dynamic> update,
    [RemoteUpdateOptions updateOptions]
  );

  /// Opens a MongoDB change stream against the collection to watch for changes.
  /// You can watch a subset of the documents in the collection by passing
  /// an array of specific document ids or a
  /// [match expression](https://docs.mongodb.com/manual/reference/operator/aggregation/match/)
  /// that filters the [[ChangeEvent]]s from the change stream.
  ///
  /// Defining the match expression to filter ChangeEvents is similar to
  /// defining the match expression for [triggers](https://docs.mongodb.com/stitch/triggers/database-triggers/).
  Future<Stream<ChangeEvent<DocumentT>>> watch([dynamic arg]);

  /// Opens a MongoDB change stream against the collection to watch for changes 
  /// made to specific documents. The documents to watch must be explicitly 
  /// specified by their _id.
  /// 
  /// Requests a stream where the full document of update events, and several 
  /// other unnecessary fields are omitted from the change event objects 
  /// returned by the server. This can save on network usage when watching
  /// large documents.
  Future<Stream<CompactChangeEvent<DocumentT>>> watchCompact(List<dynamic> ids);
}
