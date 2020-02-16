import 'package:stitch_core/stitch_core.dart' show CoreStitchServiceClient, Decoder;

class CollectionDecoder<T> implements Decoder<List<T>> {
  final Decoder<T> decoder;

  CollectionDecoder(this.decoder);

  decode(dynamic from) {
    if (from is List) {
      return from.map((t) => decoder.decode(t)).toList();
    }

    return [decoder.decode(from)];
  }
}

class CoreRemoteMongoReadOperation<T> {
  Decoder<List<T>> _collectionDecoder;

  String command;
  dynamic args;
  CoreStitchServiceClient service;  

  CoreRemoteMongoReadOperation(
    this.command,
    this.args,
    this.service,
    [Decoder<T> decoder]
  ) {
    if (decoder != null) {
      _collectionDecoder = CollectionDecoder<T>(decoder);
    }
  }

  Future<Iterator<T>> iterator() async {
    List<T> res = await executeRead();
    // res[Symbol.iterator]();
    return res.iterator;
  }

  Future<T> first() {
    return this.executeRead().then((res) => res[0]);
  }

  Future<List<T>> toArray() {
    return this.executeRead();
  }

  Future<List<T>> asArray() {
    return this.toArray();
  }

  Future<List<T>> executeRead() async {
    return await this.service.callFunction(
      this.command,
      [this.args],
      _collectionDecoder
    );
  }
}