
import 'dart:async';

import './core_stitch_auth.dart' show CoreStitchAuth;
import './core_stitch_user.dart' show CoreStitchUser;
import './jwt.dart' show JWT;

const SLEEP_MILLIS = 60000;
const EXPIRATION_WINDOW_SECS = 300;

/// A class containing functionality to proactively refresh access tokens
/// to prevent the server from getting too many invalid session errors.
class AccessTokenRefresher<T extends CoreStitchUser> {
  // A `CoreStitchAuth` for which this refresher will attempt to refresh tokens.
  final CoreStitchAuth<T> auth;

  dynamic _nextTimeout;
  Future<dynamic> futureDelay;
  StreamSubscription futureSubscription;

  AccessTokenRefresher(this.auth);

  /// Checks if the access token in the `CoreStitchAuth` referenced by `auth` needs to be refreshed.
  bool shouldRefresh() {
    if (auth == null) {
      return false;
    }

    if (!auth.isLoggedIn) {
      return false;
    }

    var info = auth.authInfo;
    if (info == null) {
      return false;
    }

    if (!info.isLoggedIn) {
      return false;
    }

    JWT jwt;
    try {
      jwt = JWT.fromEncoded(info.accessToken);
    } catch (e) {
      print(e);
      return false;
    }

    // Check if it's time to refresh the access token
    if (DateTime.now().millisecondsSinceEpoch / 1000 < jwt.expires - EXPIRATION_WINDOW_SECS) {
      return false;
    }

    return true;
  }

  /// Infinitely loops, checking if a proactive token refresh is necessary,
  /// every `sleepMillis` milliseconds. If the `CoreStitchAuth` referenced in `
  /// auth` is deallocated, the loop will end.
  run() async {
    if (futureSubscription != null) {
      futureSubscription.cancel();
    }

    if (shouldRefresh()) {
      // _nextTimeout = setTimeout(() => this.run(), SLEEP_MILLIS);
      await this.auth.refreshAccessToken();
    }

    futureDelay = Future.delayed(const Duration(milliseconds: SLEEP_MILLIS));
    futureSubscription = futureDelay.asStream().listen((p) => run());
  }

  /// Stops the run loop.
  stop() {
    if (futureSubscription != null) {
      futureSubscription.cancel();
    }
  }
}
