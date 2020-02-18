import 'dart:convert';

import 'package:stitch_core/stitch_exception.dart';

import '../../../internal/common/storage.dart' show Storage;

import '../auth_info.dart' show AuthInfo;
import './store_core_user_profile.dart' show StoreCoreUserProfile;
import './store_stitch_user_identity.dart' show StoreStitchUserIdentity;

class Fields {
  static const String USER_ID = 'user_id';
  static const String DEVICE_ID = 'device_id';
  static const String ACCESS_TOKEN = 'access_token';
  static const String REFRESH_TOKEN = 'refresh_token';
  static const String LAST_AUTH_ACTIVITY = 'last_auth_activity';
  static const String LOGGED_IN_PROVIDER_TYPE = 'logged_in_provider_type';
  static const String LOGGED_IN_PROVIDER_NAME = 'logged_in_provider_name';
  static const String USER_PROFILE = 'user_profile';
}

Future<AuthInfo> readActiveUserFromStorage(Storage storage) async {
  var rawInfo = await storage.gets(StoreAuthInfo.ACTIVE_USER_STORAGE_NAME);
  if (rawInfo == null) {
    return null;
  }

  return StoreAuthInfo.decode(json.decode(rawInfo));
}

Future<Map<String, AuthInfo>> readCurrentUsersFromStorage(
    Storage storage) async {
  
  String rawInfo = await storage.gets(StoreAuthInfo.ALL_USERS_STORAGE_NAME);
  if (rawInfo == null) {
    return new Map<String, AuthInfo>();
  }

  var tempRawArray = json.decode(rawInfo);

  if (!(tempRawArray is List)) {
    // The raw data is expected to be a List
    throw new StitchException(
      'CouldNotLoadPersistedAuthInfo'
    );
  }

  //TODO: efficiency
  List rawArray = tempRawArray as List;

  Map<String, AuthInfo> userIdToAuthInfoMap = Map<String, AuthInfo>();
  rawArray.forEach((rawEntry) {
    var authInfo = StoreAuthInfo.decode(rawEntry);
    userIdToAuthInfoMap[authInfo.userId] = authInfo;
  });

  return userIdToAuthInfoMap;
}

writeActiveUserAuthInfoToStorage(AuthInfo authInfo, Storage storage) {
  if (authInfo.isEmpty) {
    storage.remove(StoreAuthInfo.ACTIVE_USER_STORAGE_NAME);
    return;
  }

  List<StoreStitchUserIdentity> identities = [];
  if (authInfo.userProfile != null) {
    authInfo.userProfile.identities.forEach((obj) {
      identities.add(StoreStitchUserIdentity(obj.id, obj.providerType));
    });
  }

  StoreAuthInfo info = StoreAuthInfo(
      authInfo.userId,
      authInfo.deviceId,
      authInfo.accessToken,
      authInfo.refreshToken,
      authInfo.loggedInProviderType,
      authInfo.loggedInProviderName,
      authInfo.lastAuthActivity,
      authInfo.userProfile != null
          ? new StoreCoreUserProfile(
              authInfo.userProfile.userType,
              authInfo.userProfile.data,
              identities)
          : null);
  storage.sets(
      StoreAuthInfo.ACTIVE_USER_STORAGE_NAME, json.encode(info.encode()));
}

writeAllUsersAuthInfoToStorage(
    Map<String, AuthInfo> currentUsersAuthInfo, Storage storage) {
  List<dynamic> encodedStoreInfos = [];

  currentUsersAuthInfo.forEach((String userId, AuthInfo authInfo) {
    StoreAuthInfo storeInfo = StoreAuthInfo(
        userId,
        authInfo.deviceId,
        authInfo.accessToken,
        authInfo.refreshToken,
        authInfo.loggedInProviderType,
        authInfo.loggedInProviderName,
        authInfo.lastAuthActivity,
        authInfo.userProfile != null
            ? new StoreCoreUserProfile(
                authInfo.userProfile.userType,
                authInfo.userProfile.data,
                authInfo.userProfile.identities.map((identity) =>
                    new StoreStitchUserIdentity(
                        identity.id, identity.providerType)).toList())
            : null);

    encodedStoreInfos.add(storeInfo.encode());
  });

  storage.sets(
      StoreAuthInfo.ALL_USERS_STORAGE_NAME, json.encode(encodedStoreInfos));
}

class StoreAuthInfo extends AuthInfo {
  static const String ACTIVE_USER_STORAGE_NAME = 'auth_info';
  static const String ALL_USERS_STORAGE_NAME = 'all_auth_infos';

  final StoreCoreUserProfile userProfile;

  static StoreAuthInfo decode(Map<String, dynamic> from) {
    String userId = from[Fields.USER_ID];
    String deviceId = from[Fields.DEVICE_ID];
    String accessToken = from[Fields.ACCESS_TOKEN];
    String refreshToken = from[Fields.REFRESH_TOKEN];
    String loggedInProviderType = from[Fields.LOGGED_IN_PROVIDER_TYPE];
    String loggedInProviderName = from[Fields.LOGGED_IN_PROVIDER_NAME];
    Map<String, dynamic> userProfile = from[Fields.USER_PROFILE];
    int lastAuthActivityMillisSinceEpoch = from[Fields.LAST_AUTH_ACTIVITY];

    return StoreAuthInfo(
      userId,
      deviceId,
      accessToken,
      refreshToken,
      loggedInProviderType,
      loggedInProviderName,
      lastAuthActivityMillisSinceEpoch != null ? DateTime.fromMillisecondsSinceEpoch(lastAuthActivityMillisSinceEpoch) : null,
      StoreCoreUserProfile.decode(userProfile),
    );
  }

  StoreAuthInfo(
      String userId,
      String deviceId,
      String accessToken,
      String refreshToken,
      String loggedInProviderType,
      String loggedInProviderName,
      DateTime lastAuthActivity,
      StoreCoreUserProfile userProfile)
      : this.userProfile = userProfile,
        super(userId, deviceId, accessToken, refreshToken, loggedInProviderType,
            loggedInProviderName, lastAuthActivity, userProfile);

  Map<String, dynamic> encode() {
    Map<String, dynamic> to = {};

    to[Fields.USER_ID] = userId;
    
    to[Fields.REFRESH_TOKEN] = refreshToken;
    to[Fields.DEVICE_ID] = deviceId;
    to[Fields.LOGGED_IN_PROVIDER_NAME] = loggedInProviderName;
    to[Fields.LOGGED_IN_PROVIDER_TYPE] = loggedInProviderType;
    to[Fields.LAST_AUTH_ACTIVITY] = lastAuthActivity != null
        ? this.lastAuthActivity.millisecondsSinceEpoch
        : null;
    to[Fields.USER_PROFILE] =
        userProfile != null ? this.userProfile.encode() : null;

    to[Fields.ACCESS_TOKEN] = accessToken;

    return to;
  }
}
