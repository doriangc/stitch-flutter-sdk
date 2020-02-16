class RemoteMongoCursor<T> {
  final Iterator<T> proxy;
  RemoteMongoCursor(
    this.proxy
  );

  ///  Retrieves the next document in this cursor, potentially fetching from the 
  /// server.
  T next() {
    proxy.moveNext();
    return proxy.current;
  }
}