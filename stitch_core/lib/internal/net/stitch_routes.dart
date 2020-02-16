const BASE_ROUTE = "/api/client/v2.0";

String getAppRoute(String clientAppId) {
  return BASE_ROUTE + '/app/$clientAppId';
}

String getFunctionCallRoute(String clientAppId) {
  return getAppRoute(clientAppId) + "/functions/call";
}

String getAppMetadataRoute(String clientAppId) {
  return getAppRoute(clientAppId) + "/location";
}