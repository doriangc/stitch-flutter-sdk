import 'package:stitch_core/stitch_core.dart' show
  Codec,
  ChangeEvent,
  CompactChangeEvent,
  CoreRemoteMongoCollection,
  RemoteCountOptions,
  RemoteDeleteResult,
  RemoteFindOneAndModifyOptions,
  RemoteFindOptions,
  RemoteInsertManyResult,
  RemoteInsertOneResult,
  RemoteUpdateOptions,
  RemoteUpdateResult,
  Stream;

import '../remote_mongo_collection.dart' show RemoteMongoCollection;
import '../remote_mongo_read_operation.dart' show RemoteMongoReadOperation;

class RemoteMongoCollectionImpl<DocumentT> implements RemoteMongoCollection<DocumentT> {
  final CoreRemoteMongoCollection<DocumentT> _proxy;

  /// Gets the namespace of this collection.
  final String namespace;

  RemoteMongoCollectionImpl(
    CoreRemoteMongoCollection<DocumentT> proxy
  ) : 
    _proxy = proxy,
    namespace = proxy.namespace;

  //// Create a new CoreRemoteMongoCollection instance with a different default class to cast any
  /// documents returned from the database into.
  RemoteMongoCollectionImpl<U> withCollectionType<U>(Codec<U> codec) {
    return RemoteMongoCollectionImpl(
      _proxy.withCollectionType(codec)
    );
  }

  /// Counts the number of documents in the collection.
  Future<int> count([Map<String, dynamic> query, RemoteCountOptions options]) {
    return _proxy.count(query, options);
  }

  /// Finds all documents in the collection.
  RemoteMongoReadOperation<DocumentT> find([
    Map<String, dynamic> query,
    RemoteFindOptions options
  ]) {
    return RemoteMongoReadOperation(
      _proxy.find(query, options)
    );
  }

  /// Finds one document in the collection.
  Future<DocumentT> findOne([
    Map<String, dynamic> query,
    RemoteFindOptions options
  ]) {
    return _proxy.findOne(query, options);
  }

  /// Finds one document in the collection that matches the given query and performs the 
  /// given update on that document. (An empty query {} will match all documents)
  Future<DocumentT> findOneAndUpdate(
    Map<String, dynamic> query,
    Map<String, dynamic> update, 
    [RemoteFindOneAndModifyOptions options]
  ) {
    return _proxy.findOneAndUpdate(query, update, options);
  }

  /// Finds one document in the collection that matches the given query and replaces that document 
  /// with the given replacement. (An empty query {} will match all documents)
  Future<DocumentT> findOneAndReplace(
    Map<String, dynamic> query,
    Map<String, dynamic> replacement, 
    [RemoteFindOneAndModifyOptions options]
  ) {
    return _proxy.findOneAndReplace(query, replacement, options);
  }

  /// Finds one document in the collection that matches the given query and 
  /// deletes that document. (An empty query {} will match all documents)
  Future<DocumentT> findOneAndDelete(
    Map<String, dynamic> query,
    [RemoteFindOneAndModifyOptions options]
  ) {
    return _proxy.findOneAndDelete(query, options);
  }

  /// Aggregates documents according to the specified aggregation pipeline.
  RemoteMongoReadOperation<DocumentT> aggregate(List<Map<String, dynamic>> pipeline) {
    return RemoteMongoReadOperation(
      _proxy.aggregate(pipeline)
    );
  }

  /// Inserts the provided document. If the document is missing an identifier, the client should
  /// generate one.
  Future<RemoteInsertOneResult> insertOne(DocumentT doc) {
    return _proxy.insertOne(doc);
  }

  /// Inserts one or more documents.
  Future<RemoteInsertManyResult> insertMany(List<DocumentT> docs) {
    return _proxy.insertMany(docs);
  }

  /// Removes at most one document from the collection that matches the given filter.  If no
  /// documents match, the collection is not
  /// modified.
  Future<RemoteDeleteResult> deleteOne(Map<String, dynamic> query) {
    return _proxy.deleteOne(query);
  }

  /// Removes all documents from the collection that match the given query filter.  If no documents
  /// match, the collection is not modified.
  ///
  Future<RemoteDeleteResult> deleteMany(Map<String, dynamic> query) {
    return _proxy.deleteMany(query);
  }

  /// Update a single document in the collection according to the specified arguments.
  Future<RemoteUpdateResult> updateOne(
    Map<String, dynamic> query,
    Map<String, dynamic> update,
    [RemoteUpdateOptions updateOptions]
  ) {
    return _proxy.updateOne(query, update, updateOptions);
  }

  /// Update all documents in the collection according to the specified arguments.
  Future<RemoteUpdateResult> updateMany(
    Map<String, dynamic> query,
    Map<String, dynamic> update,
    [RemoteUpdateOptions updateOptions]
  ) {
    return _proxy.updateMany(query, update, updateOptions);
  }

  Future<Stream<ChangeEvent<DocumentT>>> watch(dynamic arg) {
    return _proxy.watch(arg);
  }

  Future<Stream<CompactChangeEvent<DocumentT>>> watchCompact(List<dynamic> ids) {
    return _proxy.watchCompact(ids);
  }
}
