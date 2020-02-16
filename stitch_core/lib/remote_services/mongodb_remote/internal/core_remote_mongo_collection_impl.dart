import 'package:bson/bson.dart' show ObjectId;
import 'package:stitch_core/stitch_core.dart' show Codec, CoreStitchServiceClient, Stream;
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
import './core_remote_mongo_collection.dart' show CoreRemoteMongoCollection;
import './core_remote_mongo_read_operation.dart' show CoreRemoteMongoReadOperation;
import './result_decoders.dart' show ResultDecoders;


class CoreRemoteMongoCollectionImpl<T> implements CoreRemoteMongoCollection<T> {
  final String namespace;

  final String name;
  final String databaseName;

  final CoreStitchServiceClient _service;
  final Codec<T> _codec;


  final Map<String, String> _baseOperationArgs;

  CoreRemoteMongoCollectionImpl(
    this.name,
    this.databaseName,
    CoreStitchServiceClient service,
    [Codec<T> codec]
  ) :
    namespace = databaseName + "." + name,
    _service = service,
    _codec = codec,
    _baseOperationArgs = {
      'collection': name,
      'database': databaseName
    };

  /// Creates a collection using the same datatabase name and collection name, but with a new `Codable` type with
  /// which to encode and decode documents retrieved from and inserted into the collection.
  CoreRemoteMongoCollection<U> withCollectionType<U>(Codec<U> codec) {
    return new CoreRemoteMongoCollectionImpl<U>(
      name,
      databaseName,
      _service,
      codec
    );
  }

  /// Finds the documents in this collection which match the provided filter.
  ///
  /// - parameters:
  ///   - filter: A `Document` that should match the query.
  ///   - options: Optional `RemoteFindOptions` to use when executing the command.
  ///
  /// - important: Invoking this method by itself does not perform any network requests. You must call one of the
  ///              methods on the resulting `CoreRemoteMongoReadOperation` instance to trigger the operation against
  ///              the database.
  ///
  /// - returns: A `CoreRemoteMongoReadOperation` that allows retrieval of the resulting documents.
  CoreRemoteMongoReadOperation<T> find(
    Map<String, dynamic> filter,
    [RemoteFindOptions options]
  ) {
    Map<String, dynamic> args = { ..._baseOperationArgs };

    args['query'] = filter;

    if (options != null) {
      if (options.limit != null) {
        args['limit'] = options.limit;
      }
      if (options.projection != null) {
        args['project'] = options.projection;
      }
      if (options.sort != null) {
        args['sort'] = options.sort;
      }
    }

    return new CoreRemoteMongoReadOperation<T>(
      "find",
      args,
      _service,
      _codec
    );
  }

  /// Finds a document in this collection which matches the provided filter.
  ///
  /// - parameters:
  ///   - filter: A `Document` that should match the query.
  ///   - options: Optional `RemoteFindOptions` to use when executing the command.
  ///
  /// - returns: A resulting `DocumentT` or null if the query returned zero matches.
  Future<T> findOne([
    Map<String, dynamic> filter = const {},
    RemoteFindOptions options
  ]) {
    Map<String, dynamic> args = { ..._baseOperationArgs };

    args['query'] = filter;

    if (options != null) {
      if (options.projection != null) {
        args['project'] = options.projection;
      }
      if (options.sort != null) {
        args['sort'] = options.sort;
      }
    }
    return _service.callFunction(
      "findOne",
      [args],
      _codec
    );
  }
  
  /// Finds a document in this collection which matches the provided filter and performs the 
  /// desired updates
  ///
  /// - parameters:
  ///  - filter: A `Document` that should match the query.
  ///   - update: A `Document` describing the update. 
  ///   - options: Optional `RemoteFindOneAndModifyOptions` to use when executing the command.
  ///
  /// - returns: A resulting `DocumentT` or null if the query returned zero matches.
  Future<T> findOneAndUpdate(
    Map<String, dynamic> filter,
    Map<String, dynamic> update, 
    [RemoteFindOneAndModifyOptions options]
  ) {
    Map<String, dynamic> args = { ..._baseOperationArgs };

    args['filter'] = filter;
    args['update'] = update;

    if (options != null) {
      if (options.projection != null) {
        args['projection'] = options.projection;
      }
      if (options.sort != null) {
        args['sort'] = options.sort;
      }
      if (options.upsert) {
        args['upsert'] = true;
      }
      if (options.returnNewDocument) {
        args['returnNewDocument'] = true;
      }
    }
    return _service.callFunction(
      'findOneAndUpdate',
      [args],
      _codec
    );
  }

  /// Finds a document in this collection which matches the provided filter and replaces it with 
  /// A new document
  ///
  /// - parameters:
  ///   - filter: A `Document` that should match the query.
  ///   - replacement: A new `Document` to replace the old one. 
  ///   - options: Optional `RemoteFindOneAndModifyOptions` to use when executing the command.
  ///
  /// - returns: A resulting `DocumentT` or null if the query returned zero matches.
  Future<T> findOneAndReplace(
    Map<String, dynamic> filter,
    Map<String, dynamic> replacement, 
    [RemoteFindOneAndModifyOptions options]
  ) {
    Map<String, dynamic> args = { ..._baseOperationArgs };

    args['filter'] = filter;
    args['update'] = replacement;

    if (options != null) {
      if (options.projection != null) {
        args['projection'] = options.projection;
      }
      if (options.sort != null) {
        args['sort'] = options.sort;
      }
      if (options.upsert) {
        args['upsert'] = true;
      }
      if (options.returnNewDocument) {
        args['returnNewDocument'] = true;
      }
    }
    return _service.callFunction(
      'findOneAndReplace',
      [args],
      _codec
    );
  }

  /// Finds a document in this collection which matches the provided filter and performs the 
  /// desired updates
  ///
  /// - parameters:
  ///   - filter: A `Document` that should match the query.
  ///   - update: A `Document` describing the update. 
  ///   - options: Optional `RemoteFindOneAndModifyOptions` to use when executing the command.
  ///
  /// - returns: A resulting `DocumentT` or null if the query returned zero matches.
  Future<T> findOneAndDelete(
    Map<String, dynamic> filter,
    [RemoteFindOneAndModifyOptions options]
  ) {
    Map<String, dynamic> args = { ..._baseOperationArgs };

    args['filter'] = filter;

    if (options != null) {
      if (options.projection != null) {
        args['projection'] = options.projection;
      }
      if (options.sort != null) {
        args['sort'] = options.sort;
      }
    }
    return _service.callFunction(
      'findOneAndDelete',
      [args],
      _codec
    );
  }
  
  /// Runs an aggregation framework pipeline against this collection.
  ///
  /// - Parameters:
  ///   - pipeline: An `[Document]` containing the pipeline of aggregation operations to perform.
  ///
  /// - important: Invoking this method by itself does not perform any network requests. You must call one of the
  ///              methods on the resulting `CoreRemoteMongoReadOperation` instance to trigger the operation against the
  ///              database.
  ///
  /// - returns: A `CoreRemoteMongoReadOperation` that allows retrieval of the resulting documents.
  CoreRemoteMongoReadOperation<T> aggregate(List<Map<String, dynamic>> pipeline) {
    Map<String, dynamic> args = { ..._baseOperationArgs };

    args['pipeline'] = pipeline;

    return new CoreRemoteMongoReadOperation<T>(
      'aggregate',
      args,
      _service,
      _codec
    );
  }

  /// Counts the number of documents in this collection matching the provided filter.
  ///
  /// - Parameters:
  ///   - filter: a `Document`, the filter that documents must match in order to be counted.
  ///   - options: Optional `RemoteCountOptions` to use when executing the command.
  ///
  /// - Returns: The count of the documents that matched the filter.
  Future<int> count([
    Map<String, dynamic> query = const {},
    RemoteCountOptions options
  ]) {
    Map<String, dynamic> args = { ..._baseOperationArgs };
    args['query'] = query;

    if (options != null && options.limit != null) {
      args['limit'] = options.limit;
    }

    return _service.callFunction('count', [args]);
  }

  /// Encodes the provided value to BSON and inserts it. If the value is missing an identifier, one will be
  /// generated for it.
  ///
  /// - Parameters:
  ///   - value: A `CollectionType` value to encode and insert.
  ///
  /// - Returns: The result of attempting to perform the insert.
  Future<RemoteInsertOneResult> insertOne(T value) {
    Map<String, dynamic> args = { ..._baseOperationArgs };

    args['document'] = _generateObjectIdIfMissing(
      _codec != null ? _codec.encode(value) : (value as dynamic)
    );

    return _service.callFunction(
      "insertOne",
      [args],
      ResultDecoders.remoteInsertOneResultDecoder
    );
  }

  /// Encodes the provided values to BSON and inserts them. If any values are missing identifiers,
  /// they will be generated.
  ///
  /// - Parameters:
  ///   - documents: The `T` values to insert.
  ///
  /// - Returns: The result of attempting to perform the insert.
  Future<RemoteInsertManyResult> insertMany(List<T> docs) {
    Map<String, dynamic> args = { ..._baseOperationArgs };

    args['documents'] = docs.map( (doc) =>
      _generateObjectIdIfMissing(
        _codec != null ? _codec.encode(doc) : (doc as dynamic)
      )
    );

    return _service.callFunction(
      'insertMany',
      [args],
      ResultDecoders.remoteInsertManyResultDecoder
    );
  }

  /// Deletes a single matching document from the collection.
  ///
  /// - Parameters:
  ///   - filter: A `Document` representing the match criteria.
  ///
  /// - Returns: The result of performing the deletion.
  Future<RemoteDeleteResult> deleteOne(Map<String, dynamic> query) {
    return _executeDelete(query, false);
  }

  /// Deletes multiple documents
  ///
  /// - Parameters:
  ///   - filter: Document representing the match criteria
  ///
  /// - Returns: The result of performing the deletion.
  Future<RemoteDeleteResult> deleteMany(Map<String, dynamic> query) {
    return _executeDelete(query, true);
  }

  /// Updates a single document matching the provided filter in this collection.
  ///
  /// - Parameters:
  ///   - query: A `Document` representing the match criteria.
  ///   - update: A `Document` representing the update to be applied to a matching document.
  ///   - options: Optional `RemoteUpdateOptions` to use when executing the command.
  ///
  /// - Returns: The result of attempting to update a document.
  Future<RemoteUpdateResult> updateOne(
    Map<String, dynamic> query,
    Map<String, dynamic> update,
    [RemoteUpdateOptions options]
  ) {
    return _executeUpdate(query, update, options, false);
  }

  /// Updates multiple documents matching the provided filter in this collection.
  ///
  /// - Parameters:
  ///   - filter: A `Document` representing the match criteria.
  ///   - update: A `Document` representing the update to be applied to matching documents.
  ///   - options: Optional `RemoteUpdateOptions` to use when executing the command.
  ///
  /// - Returns: The result of attempting to update multiple documents.
  Future<RemoteUpdateResult> updateMany(
    Map<String, dynamic> query,
    Map<String, dynamic> update,
    [RemoteUpdateOptions options]
  ) {
    return _executeUpdate(query, update, options, true);
  }

  Future<Stream<ChangeEvent<T>>> watch(
    dynamic arg
  ) {
    Map<String, dynamic> args = { ..._baseOperationArgs };

    if (arg != null) {
      if (arg is List) {
        if (arg.length != 0) {
          args['ids'] = arg;
        }
      } else if (arg is Map) {
        args['filter'] = arg;
      }
    }

    args['useCompactEvents'] = false;

    return _service.streamFunction(
      "watch",
      [args],
      ResultDecoders.ChangeEventDecoder(_codec)
    );
  }

  Future<Stream<CompactChangeEvent<T>>> watchCompact(
    List<dynamic> ids
  ) {
    Map<String, dynamic> args = { ..._baseOperationArgs };

    args['ids'] = ids;
    args['useCompactEvents'] = true;

    return _service.streamFunction(
      "watch",
      [args],
      ResultDecoders.CompactChangeEventDecoder(_codec)
    );
  }

  Future<RemoteDeleteResult> _executeDelete(
    Map<String, dynamic> query,
    bool multi
  ) {
    Map<String, dynamic> args = { ..._baseOperationArgs };
    args['query'] = query;

    return _service.callFunction(
      multi ? "deleteMany" : "deleteOne",
      [args],
      ResultDecoders.remoteDeleteResultDecoder
    );
  }

  Future<RemoteUpdateResult> _executeUpdate(
    Map<String, dynamic> query,
    Map<String, dynamic> update,
    [RemoteUpdateOptions options,
    multi = false]
  ) {
    Map<String, dynamic> args = { ..._baseOperationArgs };

    args['query'] = query;
    args['update'] = update;

    if (options != null && options.upsert) {
      args['upsert'] = options.upsert;
    }

    return _service.callFunction(
      multi ? 'updateMany' : 'updateOne',
      [args],
      ResultDecoders.remoteUpdateResultDecoder
    );
  }

  /// Returns a version of the provided document with an ObjectId
  Map<String, dynamic> _generateObjectIdIfMissing(Map<String, dynamic> doc) {
    if (!doc.containsKey('_id')) {
      var newDoc = doc;
      newDoc['_id'] = ObjectId();
      return newDoc;
    }
    return doc;
  }
}
