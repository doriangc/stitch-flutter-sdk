import './mongo_namespace.dart' show MongoNamespace;
import './update_description.dart' show UpdateDescription;

/// Represents a change event communicated via a MongoDB change stream. This 
/// type of stream always includes a fullDocument for update events, and also 
/// includes the change event ID and namespace of the event as returned by 
/// MongoDB.
/// 
/// T is the underlying type of documents on the collection for which this 
/// change event was produced.
/// 
class ChangeEvent<T> {
  final dynamic id;
  final String operationType;
  final T fullDocument;
  final MongoNamespace namespace;
  final dynamic documentKey;
  final UpdateDescription updateDescription;

  ChangeEvent({this.id, this.operationType, this.fullDocument, this.namespace, this.documentKey, this.updateDescription});
}