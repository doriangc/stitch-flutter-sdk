class Headers {
  static const CONTENT_TYPE_CANON = 'Content-Type';
  static final CONTENT_TYPE = Headers.CONTENT_TYPE_CANON.toLowerCase();

  static const AUTHORIZATION_CANON = 'Authorization';
  static final AUTHORIZATION = Headers.AUTHORIZATION_CANON.toLowerCase();

  static const ACCEPT_CANON = 'Accept';
  static final ACCEPT = Headers.ACCEPT_CANON.toLowerCase();

  static const AUTHORIZATION_BEARER = 'Bearer';


  /// @param value The bearer value
  /// @return A standard Authorization Bearer header value.
  static String getAuthorizationBearer(String value) {
    return '${Headers.AUTHORIZATION_BEARER} $value';
  }
}