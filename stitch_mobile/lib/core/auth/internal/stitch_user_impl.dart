import 'package:stitch_core/stitch_core.dart' show CoreStitchUserImpl, StitchCredential, StitchUserProfileImpl;

import '../stitch_user.dart' show StitchUser;
import './stitch_auth_impl.dart' show StitchAuthImpl;

class StitchUserImpl extends CoreStitchUserImpl implements StitchUser {
  
  final StitchAuthImpl auth;

  StitchUserImpl(
    String id,
    String loggedInProviderType,
    String loggedInProviderName,
    bool isLoggedIn,
    DateTime lastAuthActivity,
    StitchUserProfileImpl profile,
    this.auth,
    [Map<String, dynamic> customData]
  ) :
    super(
      id, 
      loggedInProviderType, 
      loggedInProviderName, 
      isLoggedIn, 
      lastAuthActivity,
      profile,
      customData
    );

  Future<StitchUser> linkWithCredential(StitchCredential credential) {
    return this.auth.linkWithCredential(this, credential);
  }

  // Future<void> linkUserWithRedirect(
  //   StitchRedirectCredential credential
  // ) {
  //   return this.auth.linkWithRedirectInternal(this, credential);
  // }
}
