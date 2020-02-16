
import 'package:http/http.dart' as http;

import '../internal/auth_info.dart';
import '../../internal/net/response.dart';
import '../../internal/net/stitch_auth_request.dart';
import '../../internal/common/codec.dart';
import '../../stream.dart' show Stream;

/// An interface defining the methods necessary to make authenticated requests to the Stitch server.
abstract class StitchAuthRequestClient {
  /// Performs an authenticated request to the Stitch server, using the current authentication state, and should
  /// throw when not currently authenticated.
  ///
  /// - returns: The response to the request as an [http.Response].
  Future<Response> doAuthenticatedRequest(StitchAuthRequest stitchReq, [AuthInfo i]);

  // Performs an authenticated request to the Stitch server with a JSON request body, using the current
  /// authentication state, and should throw when not currently authenticated.
  ///
  /// Returns the response body as decoded JSON.
  Future<T> doAuthenticatedRequestWithDecoder<T>(
    StitchAuthRequest stitchReq,
    Decoder<T> decoder
  );

  Future<Stream<T>> openAuthenticatedStreamWithDecoder<T>(
    StitchAuthRequest stitchReq,
    Decoder<T> decoder 
  );
}
