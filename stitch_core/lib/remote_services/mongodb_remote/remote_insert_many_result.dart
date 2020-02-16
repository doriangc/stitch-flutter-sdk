/// The result of an `insertMany` command on a [[RemoteMongoCollection]].
class RemoteInsertManyResult {
  /// Map of the index of the inserted document to the new id of the inserted document.
  ///
  /// If the document doesn't have an identifier, this value will be generated
  /// by the Stitch server and added to the document before insertion.
  Map<int, String> insertedIds;

  // Given an ordered array of insertedIds, creates a corresponding 
  RemoteInsertManyResult(List<dynamic>arr) {
    const inserted = {};
    int index = 0;
    arr.forEach((value){
      inserted[index] = value;
      index++;
    });
    this.insertedIds = inserted;
  }
}