import 'package:flutter_test/flutter_test.dart';

import 'package:stitch_mobile/stitch_mobile.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  StitchAppClient stitchClient = await Stitch.initializeDefaultAppClient("stitch-quickstarts-zhpox");

  await stitchClient.auth.initProcess();
  // StitchUser user = await stitchClient.auth.loginWithCredential(AnonymousCredential());
  // print('logged in as anonymous user with id: ${user.id}');
}
