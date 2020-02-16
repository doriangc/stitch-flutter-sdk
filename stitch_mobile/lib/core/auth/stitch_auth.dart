import 'package:stitch_core/stitch_core.dart' show StitchCredential;
import './stitch_user.dart';
import './stitch_auth_listener.dart';
import 'providers/stitch_redirect_credential.dart';
import 'providers/internal/auth_provider_client_factory.dart';

/// StitchAuth represents and controls the login state of a [[StitchAppClient]]. 
///
/// Login is required for most Stitch functionality. Depending on which
/// "Authentication Provider"(https://docs.mongodb.com/stitch/authentication/)
/// you are using, use [loginWithCredential] or [loginWithRedirect] to log in.
///
/// Once logged in, [StitchAuth.user] is a [StitchUser] object that can be examined for 
/// user profile and other information.
/// 
/// Login state can persist across browser sessions. Therefore, a StitchAppClient's
/// StitchAuth instance may already contain login information upon initialization.
/// 
/// In the case of OAuth2 authentication providers, StitchAuth may also initialize with
/// the result of a previous session's request to [loginWithRedirect]. The redirect
/// result can be checked with [hasRedirectResult] and handled with [handleRedirectResult].
///
/// To log out, use [logout].
///
/// For an example of [loginWithRedirect], see "Facebook Authentication"(https://docs.mongodb.com/stitch/authentication/facebook/).

abstract class StitchAuth {
  /// Whether or not there is a currently logged in active user of this 
  /// [StitchAuth]
  // bool isLoggedIn;

  /// A [StitchUser] object representing the currently logged in, active user,
  /// or `null` if there is no logged in active user.
  // StitchUser user;

  /// Returns a list of all users who have logged into this application, except
  /// those that have been removed manually and anonymous users who have logged
  /// out.
  ///
  /// Note that the list of users is a snapshot of the state when listUsers() is called.
  /// The [StitchUsers] in this list will not be updated if, e.g., a user's
  /// login state changes after this is called.
  List<StitchUser> listUsers();

  /// Switches the active user to the user with the specified id. The user must
  /// exist in the list of all users who have logged into this application, and
  /// the user must be currently logged in, otherwise this will throw a
  /// [StitchClientError].
  /// Throws an exception if the user with the provided userId is not found, or the found 
  /// user is not logged in
  StitchUser switchToUserWithId(String userId);
 
  /// Retrieves the authentication provider client for the authentication 
  /// provider associated with the specified factory.
  ClientT getProviderClient<ClientT>(
    AuthProviderClientFactory<ClientT> clientFactory,
    [String providerName]
  );

  /// Retrieves the authentication provider client for the authentication 
  /// provider associated with the specified factory and auth provider name.
  /// 
  /// @param factory The factory that produces the desired client.
  // T getProviderClientByName<T>(
  //   NamedAuthProviderClientFactory<T> providerFactory,
  //   String providerName
  // );

  /// Logs in as a [StitchUser] using the provided [StitchCredential].
  Future<StitchUser> loginWithCredential(StitchCredential credential);

  /// Authenticates the client as a MongoDB Stitch user using the provided 
  /// [StitchRedirectCredential].
  /// 
  /// This method will redirect the user to an OAuth2 login page where the 
  /// login is handled externally. That external page will redirect the user 
  /// back to the page specified in the redirect credential. To complete 
  /// the login, that page will need to handle the redirect by calling
  /// [handleRedirectResult].
  ///
  /// For usage examples, see [Facebook Authentication](https://docs.mongodb.com/stitch/authentication/facebook/)
  /// and [Google Authentication](https://docs.mongodb.com/stitch/authentication/google/).
  // void loginWithRedirect(StitchRedirectCredential credential);

  /// Checks whether or not an external login process previously started by [loginWithRedirect]
  /// has redirected the user to this page.
  /// 
  /// Stitch will have this information available right after initialization.
  /// 
  /// Call this method before calling [handleRedirectResult] if you want to avoid errors.
  // bool hasRedirectResult();

  /// If [hasRedirectResult] is true, completes the OAuth2 login previously started by [loginWithRedirect].
  // Future<StitchUser> handleRedirectResult();

  /// Logs out the currently authenticated active user and clears any persisted 
  /// authentication information for that user.
  /// 
  /// There will be no active user after this logout takes place, even if there
  /// are other logged in users. Another user must be explicitly switched to using 
  /// [switchToUserWithId], [loginWithCredential] or [loginWithRedirect].
  Future<void> logout();

  /// Logs out the user with the provided id.
  /// 
  /// The promise rejects with an exception if the user was not found.
  ///
  /// Because anonymous users are deleted after logout, this method is
  /// equivalent to [[removeUserWithId]] for anonymous users.
  Future<void> logoutUserWithId(String userId);

  /// Logs out the active user and removes that user from
  /// the list of all users associated with this application
  /// as returned by [StitchAuth.listUsers].
  Future<void> removeUser();

  /// Removes the user with the provided id from the list of all users 
  /// associated with this application as returned by [[StitchAuth.listUsers]].
  /// 
  /// If the user was logged in, the user will be logged out before being removed.
  /// 
  /// The promise rejects with an exception if the user was not found.
  Future<void> removeUserWithId(String userId);

  /// Registers a [StitchAuthListener] with the client.
  /// The provider listener will be triggered when an authentication event
  /// occurs on this auth object.
  addAuthListener(StitchAuthListener listener);

  /// Unregisters a listener.
  removeAuthListener(StitchAuthListener listener);

  /// Refresh a user's custom data field.
  Future<void> refreshCustomData();
}
