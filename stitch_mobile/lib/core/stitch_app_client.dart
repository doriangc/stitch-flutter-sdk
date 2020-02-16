import '../services/internal/named_service_client_factory.dart' show NamedServiceClientFactory;
import './auth/stitch_auth.dart' show StitchAuth;
import '../services/internal/service_client_factory.dart' show ServiceClientFactory;
import '../services/stitch_service_client.dart' show StitchServiceClient;
import 'auth/internal/stitch_auth_impl.dart';


/// The StitchAppClient is the interface to a MongoDB Stitch App backend.
///
/// It is created by the [Stitch] singleton.
///
/// The StitchAppClient holds a [StitchAuth] object for managing the login state of the client.
///
/// It provides clients for [Stitch Services](https://docs.mongodb.com/stitch/services/) including
/// the [RemoteMongoClient] for database and collection access.
///
/// Finally, the StitchAppClient can execute [Stitch Functions](https://docs.mongodb.com/stitch/functions/).

abstract class StitchAppClient {
  /// The [StitchAuth] object representing the login state of this client.
  /// Includes methods for logging in and logging out.
  ///
  /// Login state can be persisted beyond the lifetime of a browser 
  /// session. A StitchAppClient retrieved from the `Stitch` singleton may or 
  /// may not be already authenticated when first initialized.
  StitchAuthImpl auth;

  /// Retrieves the service client for the Stitch service associated with the 
  /// specified name and factory.
  /// 
  /// @param factory The factory that produces the desired service client.
  /// @param serviceName The name of the desired service in MongoDB Stitch.
  T getServiceClient<T>(
    NamedServiceClientFactory<T> serviceFactory,
    String serviceName 
  );
  
  /// Retrieves the service client for the Stitch service associated with the 
  /// specificed factory.
  /// 
  /// @param factory The factory that produces the desired service client.
  T getServiceClientByFactory<T>(ServiceClientFactory<T> serviceFactory);

  /// Retrieves a general-purpose service client for the Stitch service
  /// associated with the specified name. Use this for services which do not
  /// have a well-defined interface in the SDK.
  ///
  /// @param serviceName The name of the desired service in MongoDB Stitch.
  StitchServiceClient getGeneralServiceClient(String serviceName);

  /// Calls the MongoDB Stitch function with the provided name and arguments,
  /// and returns the result as decoded extended JSON.
  ///
  /// @param name The name of the function to call.
  /// @param args The arguments to the function.
  callFunction(String name, List<dynamic> args);
}
