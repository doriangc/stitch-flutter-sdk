import 'package:stitch_core/stitch_core.dart' show CoreStitchServiceClient, StitchAppClientInfo;

abstract class NamedServiceClientFactory<T> { 
  T getNamedClient(
    CoreStitchServiceClient service, 
    StitchAppClientInfo client
  );
}