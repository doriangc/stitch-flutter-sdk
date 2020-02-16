import 'package:stitch_core/stitch_core.dart' show
  Decoder,
  Stream;

/// StitchServiceClient acts as a general purpose client for working with
/// services that are not defined or well defined by this SDK. It functions
/// similarly to
/// {@link com.mongodb.stitch.android.core.StitchAppClient#callFunction}.

abstract class StitchServiceClient {
  /// Calls the specified Stitch service function.
  ///
  /// @param name the name of the Stitch service function to call.
  /// @param args the arguments to pass to the function.
  /// @param codec the optional codec to use to decode the result of the
  ///              function call.
  /// Returns when the request completes.
  Future<T> callFunction<T>(String name, List<dynamic> args,
      [Decoder<T> codec]);

  Future<Stream<T>> streamFunction<T>(String name, List<dynamic> args,
      [Decoder<T> decoder]);
}
