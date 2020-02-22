import 'dart:convert';

import '../../stitch_service_exception.dart';
import '../net/response.dart';
import '../../internal/net/headers.dart';
import '../net/content_types.dart';

class Fields {
  static final String ERROR = 'error';
  static final String ERROR_CODE = 'error_code';
}

/// Static utility method that accepts an HTTP response object, and throws the
/// StitchServiceError representing the the error in the response. If the error cannot be
/// recognized, this will throw a StitchServiceError with the "UNKNOWN" error code.
handleRequestError(Response response) {
  if (response.body == null) {
    throw StitchServiceException('Received unexpected status code ${response.statusCode}');
  }
  
  String body;
  try {
    body = response.body;
  } catch (e) {
    throw StitchServiceException('Received unexpected status code ${response.statusCode}');
  }

  String errorMsg = _handleRichError(response, body);

  // throw new StitchException(errorMsg);
  throw new StitchServiceException(errorMsg);
}

/// Private helper method which decodes the Stitch error from the body of an HTTP `Response`
/// object. If the error is successfully decoded, this function will throw the error for the end
/// user to eventually consume. If the error cannot be decoded, this is likely not an error from
/// the Stitch server, and this function will return an error message that the calling function
/// should use as the message of a StitchServiceError with an unknown code.
String _handleRichError(Response response, String body){
  if (
    response.headers[Headers.CONTENT_TYPE] == null ||
    (response.headers[Headers.CONTENT_TYPE] != null &&
      response.headers[Headers.CONTENT_TYPE] != ContentTypes.APPLICATION_JSON)
  ) {
    return body;
  }

  var bsonObj = jsonDecode(body);

  if (bsonObj[Fields.ERROR] == null) {
    return body;
  }

  var errorMsg = bsonObj[Fields.ERROR];
  if (bsonObj[Fields.ERROR_CODE] == null) {
    return errorMsg;
  }

  var errorCode = bsonObj[Fields.ERROR_CODE];

  return errorMsg;
}
