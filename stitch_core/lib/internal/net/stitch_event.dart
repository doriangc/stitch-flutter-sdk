import 'dart:convert';

import './event.dart' show Event;
import '../common/codec.dart' show Decoder;
import '../../stitch_exception.dart';

class ErrorFields {
  static const String Error = "error";
  static const String ErrorCode = "error_code";
}

class StitchEvent<T> {
  static const ERROR_EVENT_NAME = "error";

  static StitchEvent<T> fromEvent<T>(
    Event event,
    Decoder<T> decoder) {
    return new StitchEvent<T>(event.eventName, event.data, decoder);
  }

  String eventName;
  T data;
  StitchException error;

  StitchEvent(
    this.eventName,
    String data,
    [Decoder<T> decoder]
  ) {

    data = data != null ? data : '';
    List<String> decodedStringBuffer = [];

    for (int chIdx = 0; chIdx < data.length; chIdx++) {
      String c = data[chIdx];
      switch (c) {
        case '%':
          if (chIdx + 2 >= data.length) {
            break;
          }
          String code = data.substring(chIdx + 1, chIdx + 3);
          bool found;
          switch (code) {
            case "25":
              found = true;
              decodedStringBuffer.add("%");
              break;
            case "0A":
              found = true;
              decodedStringBuffer.add("\n");
              break;
            case "0D":
              found = true;
              decodedStringBuffer.add("\r");
              break;
            default:
              found = false;
          }
          if (found) {
            chIdx += 2;
            continue;
          }
          break;
        default:
          break;
      }
      decodedStringBuffer.add(c);
    }
    String decodedData = decodedStringBuffer.join('');

    switch (eventName) {
      case StitchEvent.ERROR_EVENT_NAME:
        String errorMsg;
        String errorCode;

        try {
          /// parse the error as json
          /// if it is not valid json, parse the body as seen in
          /// StitchException
          var errorDoc = json.decode(decodedData);
          errorMsg = errorDoc[ErrorFields.Error];
          errorCode = errorDoc[ErrorFields.ErrorCode];
        } catch (error) {
          errorMsg = decodedData;
          errorCode = 'error code unknown';
        }
        this.error = new StitchException('$errorMsg, $errorCode');
        break;
      case Event.MESSAGE_EVENT:
        this.data = json.decode(decodedData);
        if (decoder != null) {
          this.data = decoder.decode(this.data);
        }
        break;
    }
  }
}