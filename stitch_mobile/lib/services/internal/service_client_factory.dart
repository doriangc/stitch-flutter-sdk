import 'package:stitch_core/stitch_core.dart' show CoreStitchServiceClient, StitchAppClientInfo;


/// An interface describing a class that can provide clients for a particular 
/// Stitch service.
abstract class ServiceClientFactory<T> {
  T getClient(CoreStitchServiceClient service, StitchAppClientInfo client);
}
