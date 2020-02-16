
/// Options to use when executing a `findOneAndUpdate` command on a 
/// [[RemoteMongoCollection]].
abstract class RemoteFindOneAndModifyOptions {  
    /// Optional: Limits the fields to return for all matching documents. See 
    dynamic projection;
  
    /// Optional: Specifies the query sort order. Sort documents specify one or more fields to 
    /// sort on where the value of each field indicates whether MongoDB should sort it in 
    /// ascending (1) or descending (0) order. 
    /// The sort order determines which document collection.findOneAndUpdate() affects.
    dynamic sort;

    /// Optional. Default: false.
    /// A boolean that, if true, indicates that MongoDB should insert a new document that matches the
    /// query filter when the query does not match any existing documents in the collection.
    bool upsert;

    /// Optional. Default: false. 
    /// A boolean that, if true, indicates that the action should return 
    /// the document in its updated form instead of its original, pre-update form.
    bool returnNewDocument;
  }
