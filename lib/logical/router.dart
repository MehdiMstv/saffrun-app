import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saffrun_app/UI/authentication/login/login_page.dart';
import 'package:saffrun_app/UI/main/main_page.dart';
import 'package:saffrun_app/UI/splash/splash_page.dart';
import 'package:saffrun_app/constants/const.dart';

class AppRouter {
  AppRouter();

  Route? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const SplashPage());

      case HOME_PAGE_PATH:
        return MaterialPageRoute(builder: (context) => const MainPage());
      case AUTH_MENU_PATH:
        return MaterialPageRoute(builder: (context) => LoginPage());
      default:
        return null;
    }
  }
}
