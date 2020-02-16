import './update_description.dart' show UpdateDescription;

/// Represents a change event communicated via a MongoDB change stream from 
/// Stitch when watchCompact is called. These change events omit full documents 
/// from the event for updates, as well as other fields that are unnecessary in 
/// the context of Stitch.
/// 
/// T is the underlying type of documents on the collection for which this 
/// change event was produced.
class CompactChangeEvent<T> {
  final String operationType;
  final T fullDocument;
  final dynamic documentKey;
  final UpdateDescription updateDescription;
  final dynamic stitchDocumentVersion;
  final int stitchDocumentHash;

  CompactChangeEvent({this.operationType, this.fullDocument, this.documentKey, this.updateDescription, this.stitchDocumentVersion, this.stitchDocumentHash});
}