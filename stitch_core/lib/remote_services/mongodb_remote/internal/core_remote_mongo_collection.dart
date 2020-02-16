import 'package:stitch_core/stitch_core.dart' show Codec, Stream;
import '../change_event.dart' show ChangeEvent;
import '../compact_change_event.dart' show CompactChangeEvent;
import '../remote_count_options.dart' show RemoteCountOptions;
import '../remote_delete_result.dart' show RemoteDeleteResult;
import '../remote_find_one_and_modify_options.dart' show RemoteFindOneAndModifyOptions;
import '../remote_find_options.dart' show RemoteFindOptions;
import '../remote_insert_many_result.dart' show RemoteInsertManyResult;
import '../remote_insert_one_result.dart' show RemoteInsertOneResult;
import '../remote_update_options.dart' show RemoteUpdateOptions;
import '../remote_update_result.dart' show RemoteUpdateResult;
import './core_remote_mongo_read_operation.dart' show CoreRemoteMongoReadOperation;

abstract class CoreRemoteMongoCollection<DocumentT> {
  /// Gets the namespace of this collection.
  final String namespace;

  CoreRemoteMongoCollection(this.namespace);

  /// Create a new CoreRemoteMongoCollection instance with a different default class to cast any
  /// documents returned from the database into.
  ///
  /// @param codec the default class to cast any documents returned from the database into.
  /// @param <NewDocumentT> the type that the new collection will encode documents from and decode
  ///                      documents to.
  /// @return a new CoreRemoteMongoCollection instance with the different default class
  CoreRemoteMongoCollection<U> withCollectionType<U>(Codec<U> codec);

  /// Counts the number of documents in the collection.
  /// @param query the query filter
  /// @param options the options describing the count
  ///
  /// @return the number of documents in the collection
  Future<int> count([Map<String, dynamic> query, RemoteCountOptions options]);

  /// Finds all documents in the collection.
  ///
  /// @param query the query filter
  /// @return the find iterable interface
  CoreRemoteMongoReadOperation<DocumentT> find(
    Map<String, dynamic> query,
    [RemoteFindOptions options]
  );

  /// Finds one documents in the collection.
  ///
  /// @param query the query filter
  /// @return the resulting document or null if no such document exists
  Future<DocumentT> findOne([
    Map<String, dynamic> query,
    RemoteFindOptions options
  ]);

  /// Finds one document in the collection and updates that document.
  ///
  /// @param query         A document describing the query filter, which may not be null.
  /// @param update        A document describing the update, which may not be null. The update to
  ///                      Apply must include only update operators.
  /// @param options       The options to apply to the findOneAndUpdate operation
  /// 
  /// @return the resulting document or null if no such document exists
  Future<DocumentT> findOneAndUpdate(
    Map<String, dynamic> query,
    Map<String, dynamic> update,
    [RemoteFindOneAndModifyOptions options]
  );
  
  /// Finds one document in the collection and replaces it.
  ///
  /// @param query         A document describing the query filter, which may not be null.
  /// @param replacement   The document that should replace the found document. 
  ///                      The document cannot contain any MongoDB update operators.
  /// @param options       The options to apply to the findOneAndReplace operation
  /// 
  /// @return the resulting document or null if no such document exists
  Future<DocumentT> findOneAndReplace(
    Map<String, dynamic> query,
    Map<String, dynamic> replacement,
    [RemoteFindOneAndModifyOptions options]
  );

  /// Finds one document in the collection and deletes it.
  ///
  /// @param query         A document describing the query filter, which may not be null.
  /// @param replacement   The document that should replace the found document. 
  ///                      The document cannot contain any MongoDB update operators.
  /// @param options       The options to apply to the findOneAndDelete operation
  /// 
  /// @return the resulting document or null if no such document exists
  Future<DocumentT> findOneAndDelete(
    Map<String, dynamic> query,
    [RemoteFindOneAndModifyOptions options]
  );

  /// Aggregates documents according to the specified aggregation pipeline.
  ///
  /// @param pipeline the aggregation pipeline
  /// @return an iterable containing the result of the aggregation operation
  CoreRemoteMongoReadOperation<DocumentT> aggregate(List<Map<String, dynamic>> pipeline);

  /// Inserts the provided document. If the document is missing an identifier, the client should
  /// generate one.
  ///
  /// @param document the document to insert
  /// @return the result of the insert one operation
  Future<RemoteInsertOneResult> insertOne(DocumentT document);

  /// Inserts one or more documents.
  ///
  /// @param documents the documents to insert
  /// @return the result of the insert many operation
  Future<RemoteInsertManyResult> insertMany(List<DocumentT> documents);

  /// Removes at most one document from the collection that matches the given filter.  If no
  /// documents match, the collection is not
  /// modified.
  ///
  /// @param query the query filter to apply the the delete operation
  /// @return the result of the remove one operation
  Future<RemoteDeleteResult> deleteOne(Map<String, dynamic> query);

  /// Removes all documents from the collection that match the given query filter.  If no documents
  /// match, the collection is not modified.
  ///
  /// @param query the query filter to apply the the delete operation
  /// @return the result of the remove many operation
  Future<RemoteDeleteResult> deleteMany(Map<String, dynamic> query);

  /// Update a single document in the collection according to the specified arguments.
  ///
  /// @param query         a document describing the query filter, which may not be null.
  /// @param update        a document describing the update, which may not be null. The update to
  ///                      apply must include only update operators.
  /// @param updateOptions the options to apply to the update operation
  /// @return the result of the update one operation
  Future<RemoteUpdateResult> updateOne(
    Map<String, dynamic> query,
    Map<String, dynamic> update,
    [RemoteUpdateOptions updateOptions]
  );

  /// Update all documents in the collection according to the specified arguments.
  ///
  /// @param query         a document describing the query filter, which may not be null.
  /// @param update        a document describing the update, which may not be null. The update to
  ///                     apply must include only update operators.
  /// @param updateOptions the options to apply to the update operation
  /// @return the result of the update many operation
  Future<RemoteUpdateResult> updateMany(
    Map<String, dynamic> query,
    Map<String, dynamic> update,
    [RemoteUpdateOptions updateOptions]
  );

  Future<Stream<ChangeEvent<DocumentT>>> watch(
    dynamic arg
  );

  Future<Stream<CompactChangeEvent<DocumentT>>> watchCompact(
    List<dynamic> ids
  );
}
