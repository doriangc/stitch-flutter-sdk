abstract class Decoder<T> {
  T decode(dynamic from);
}

abstract class Encoder<T> {
  encode(T from);
}

abstract class Codec<T> implements Decoder<T>, Encoder<T> {}