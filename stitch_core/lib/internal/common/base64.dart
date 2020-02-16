import 'dart:convert';

import 'dart:typed_data';

// Sourced from https://github.com/coolaj86/TextEncoderLite
String customBase64Decode(String str) {
  int unevenBytes = str.length % 4;
  String strToDecode;
  if (unevenBytes != 0) {
    int paddingNeeded = 4 - unevenBytes;
    strToDecode = str + "="*paddingNeeded;
  } else {
    strToDecode = str;
  }
  // List<int> bytes = utf8.encode(strToDecode);
  return utf8.decode(base64.decode(strToDecode));
}

String customBase64Encode(String str) {
  // if ("undefined" == typeof Uint8Array) {
  //   result = utf8ToBytes(str);
  // }
  Uint8List result = utf8.encode(str);
  return base64.encode(result);
}
