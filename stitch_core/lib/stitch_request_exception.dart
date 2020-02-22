import './stitch_exception.dart';

class StitchRequestExceptionCode {
  static const TRANSPORT_ERROR = 'the request transport encountered an error communicating with Stitch';
  static const DECODING_ERROR = 'an error occurred while decoding a response from Stitch';
  static const ENCODING_ERROR = 'an error occurred while encoding a request for Stitch';
}

class StitchRequestException extends StitchException {
  StitchRequestException([String message]) : super(message);
}

class StitchTransportException extends StitchRequestException {
  StitchTransportException([String message]) : super(message);
}