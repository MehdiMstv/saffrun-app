import 'package:saffrun_app/data_managment/splash/splash_networkservice.dart';
import 'package:saffrun_app/models/user/user_2.dart';

import '../../main.dart';

class SplashRepository {
  late SplashNetworkService splashNetworkService;

  SplashRepository() {
    splashNetworkService = SplashNetworkService();
  }

  Future<bool> haveTokenAndValid() async {
    try {
      bool status = await splashNetworkService.haveTokenFromServerValid();
      if (status) {
        dynamic result = await splashNetworkService.fetchProfile();
        if (result == null) {
          return false;
        }
        await splashNetworkService
            .sendNotifToken(await najva.getSubscribedToken());
        UserProfile.userLogin = UserProfile.fromJson(result);
      }
      return status;
    }
    catch (e) {
      print(e);
      rethrow;
    }
  }
}