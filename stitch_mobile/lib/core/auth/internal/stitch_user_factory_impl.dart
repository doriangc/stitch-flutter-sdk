import 'package:stitch_core/stitch_core.dart'
    show StitchUserFactory, StitchUserProfileImpl;

import '../stitch_user.dart' show StitchUser;
import './stitch_auth_impl.dart' show StitchAuthImpl;
import './stitch_user_impl.dart' show StitchUserImpl;

class StitchUserFactoryImpl implements StitchUserFactory<StitchUser> {
  final StitchAuthImpl _auth;

  StitchUserFactoryImpl(StitchAuthImpl auth) : _auth = auth;

  StitchUser makeUser(String id, String loggedInProviderType,
      String loggedInProviderName, bool isLoggedIn, DateTime lastAuthActivity,
      [StitchUserProfileImpl userProfile, Map<String, dynamic> customData]) {
    return new StitchUserImpl(id, loggedInProviderType, loggedInProviderName,
        isLoggedIn, lastAuthActivity, userProfile, _auth, customData);
  }
}
