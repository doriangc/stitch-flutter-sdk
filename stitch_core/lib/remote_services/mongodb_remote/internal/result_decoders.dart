import 'package:stitch_core/remote_services/mongodb_remote/mongo_namespace.dart';
import 'package:stitch_core/stitch_core.dart' show Decoder;
import '../change_event.dart' show ChangeEvent;
import '../compact_change_event.dart' show CompactChangeEvent;
import '../operation_type.dart' show operationTypeFromRemote;
import '../remote_delete_result.dart' show RemoteDeleteResult;
import '../remote_insert_many_result.dart' show RemoteInsertManyResult;
import '../remote_insert_one_result.dart' show RemoteInsertOneResult;
import '../remote_update_result.dart' show RemoteUpdateResult;
import '../update_description.dart' show UpdateDescription;


class RemoteInsertManyResultFields {
  static const String InsertedIds = 'insertedIds';
}

class RemoteInsertOneResultFields {
  static const String InsertedId = "insertedId";
}

class RemoteUpdateResultFields {
  static const String MatchedCount = "matchedCount",
  ModifiedCount = "modifiedCount",
  UpsertedId = "upsertedId";
}

class RemoteDeleteResultFields {
  static const String DeletedCount = "deletedCount";
}

class UpdateDescriptionFields {
  static const String UpdatedFields = "updatedFields",
  RemovedFields = "removedFields";
}

class ChangeEventFields {
  static const String Id = "_id",
  OperationType = "operationType",
  FullDocument = "fullDocument",
  DocumentKey = "documentKey",
  Namespace = "ns",
  NamespaceDb = "db",
  NamespaceColl = "coll",
  UpdateDescription = "updateDescription";
}

class CompactChangeEventFields {
  static const String OperationType = "ot",
  FullDocument = "fd",
  DocumentKey = "dk",
  UpdateDescription = "ud",
  StitchDocumentVersion = "sdv",
  StitchDocumentHash = "sdh";
}

class RemoteInsertManyResultDecoder implements Decoder<RemoteInsertManyResult> {
  decode(dynamic from) {
    return RemoteInsertManyResult(
      from[RemoteInsertManyResultFields.InsertedIds]
    );
  }
}

class RemoteInsertOneResultDecoder implements Decoder<RemoteInsertOneResult> {
  decode(dynamic from) {
    return RemoteInsertOneResult(
      insertedId: from[RemoteInsertOneResultFields.InsertedId]
    );
  }
}

class RemoteUpdateResultDecoder implements Decoder<RemoteUpdateResult> {
  decode(dynamic from) {
    return RemoteUpdateResult(
      matchedCount: from[RemoteUpdateResultFields.MatchedCount],
      modifiedCount: from[RemoteUpdateResultFields.ModifiedCount],
      upsertedId: from[RemoteUpdateResultFields.UpsertedId]
    );
  }
}

class RemoteDeleteResultDecoder implements Decoder<RemoteDeleteResult> {
  decode(dynamic from) {
    return RemoteDeleteResult(
      deletedCount: from[RemoteDeleteResultFields.DeletedCount]
    );
  }
}

class UpdateDescriptionDecoder implements Decoder<UpdateDescription> {
  decode(dynamic from) {
    // Assertions.keyPresent(UpdateDescriptionFields.UpdatedFields, from);
    // Assertions.keyPresent(UpdateDescriptionFields.RemovedFields, from);
  
    return UpdateDescription(
      removedFields: from[UpdateDescriptionFields.RemovedFields],
      updatedFields: from[UpdateDescriptionFields.UpdatedFields],
    );
  }
}

BaseChangeEventFields<T> decodeBaseChangeEventFields<T>(
   Map from,
   String updateDescriptionField,
   String fullDocumentField,
   [Decoder<T> decoder]
) {
  // decode the updateDescription
  UpdateDescription updateDescription;
  if (from.containsKey(updateDescriptionField)) {
    updateDescription = ResultDecoders.updateDescriptionDecoder.decode(
      from[updateDescriptionField]
    );
  } else {
    updateDescription = null;
  }

  // decode the full document
  T fullDocument;
  if (from.containsKey(fullDocumentField)) {
    fullDocument = from[fullDocumentField];
    if (decoder = null) {
      fullDocument = decoder.decode(fullDocument);
    }
  } else {
    fullDocument = null;
  }

  return BaseChangeEventFields(updateDescription, fullDocument);
}

class ChangeEventDecoder<T> implements Decoder<ChangeEvent<T>> {
  final Decoder<T> decoder;

  ChangeEventDecoder([this.decoder]);

  ChangeEvent<T> decode(dynamic from) {
    // Assertions.keyPresent(ChangeEventFields.Id, from);
    // Assertions.keyPresent(ChangeEventFields.OperationType, from);
    // Assertions.keyPresent(ChangeEventFields.Namespace, from);
    // Assertions.keyPresent(ChangeEventFields.DocumentKey, from);
    
    var nsDoc = from[ChangeEventFields.Namespace];

    BaseChangeEventFields decodeResult = decodeBaseChangeEventFields(
      from,
      ChangeEventFields.UpdateDescription,
      ChangeEventFields.FullDocument,
      this.decoder
    );

    var updateDescription = decodeResult.updateDescription, 
      fullDocument = decodeResult.fullDocument;

    return ChangeEvent(
      documentKey: from[ChangeEventFields.DocumentKey],
      fullDocument: fullDocument,
      id: from[ChangeEventFields.Id],
      namespace: MongoNamespace(
        collection: nsDoc[ChangeEventFields.NamespaceColl],
        database: nsDoc[ChangeEventFields.NamespaceDb]
      ),
      operationType: operationTypeFromRemote(
        from[ChangeEventFields.OperationType]
      ),
      updateDescription: updateDescription
    );
  }
}

class CompactChangeEventDecoder<T> implements Decoder<CompactChangeEvent<T>> {
  final Decoder<T> decoder;

  CompactChangeEventDecoder([this.decoder]);

  CompactChangeEvent<T> decode(dynamic from) {   
    var fields = decodeBaseChangeEventFields(
      from,
      CompactChangeEventFields.UpdateDescription,
      CompactChangeEventFields.FullDocument,
      this.decoder
    );

    var updateDescription = fields.updateDescription,
      fullDocument = fields.fullDocument;

    UpdateDescription stitchDocumentVersion;
    if (from.containskey(CompactChangeEventFields.StitchDocumentVersion)) {
      stitchDocumentVersion = from[
        CompactChangeEventFields.StitchDocumentVersion
      ];
    } else {
      stitchDocumentVersion = null;
    }

    int stitchDocumentHash;
    if (from.containsKey(CompactChangeEventFields.StitchDocumentHash)) {
      stitchDocumentHash = from[
        CompactChangeEventFields.StitchDocumentHash
      ];
    } else {
      stitchDocumentHash = null;
    }

    return CompactChangeEvent<T>(
      documentKey: from[
        CompactChangeEventFields.DocumentKey
      ],
      fullDocument: fullDocument,
      operationType: operationTypeFromRemote(
        from[CompactChangeEventFields.OperationType]
      ),
      stitchDocumentHash: stitchDocumentHash,
      stitchDocumentVersion: stitchDocumentVersion,
      updateDescription: stitchDocumentVersion,
    );
  }
}

class ResultDecoders {
  static var remoteInsertManyResultDecoder = new RemoteInsertManyResultDecoder();
  static var remoteInsertOneResultDecoder = new RemoteInsertOneResultDecoder();
  static var remoteUpdateResultDecoder = new RemoteUpdateResultDecoder();
  static var remoteDeleteResultDecoder = new RemoteDeleteResultDecoder();
  static var updateDescriptionDecoder = new UpdateDescriptionDecoder();

  // These decoders are not instantiated here, since each decoder has its own 
  // decoder for the full document type, which may differ for each collection.
  static var ChangeEventDecoder;
  static var CompactChangeEventDecoder;
}

class BaseChangeEventFields<T> {
  final UpdateDescription updateDescription;
  final T fullDocument;

  BaseChangeEventFields(this.updateDescription, this.fullDocument);
}