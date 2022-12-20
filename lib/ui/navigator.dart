import 'package:courseproject_ui_dd2022/ui/pages/app.dart';
import 'package:courseproject_ui_dd2022/ui/pages/auth.dart';
import 'package:courseproject_ui_dd2022/ui/pages/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:courseproject_ui_dd2022/ui/pages/loader.dart';

import 'pages/post_creation.dart';

class NavigationRoutes {
  static const loaderWidget = "/";
  static const auth = "/auth";
  static const app = "/app";
  static const register = "/register";
  static const postCreate = "/postCreate";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static void toLoader() {
    key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.loaderWidget, ((route) => false));
  }

  static void toAuth() {
    key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.auth, ((route) => false));
  }

  static void toRegister() {
    key.currentState?.pushNamed(NavigationRoutes.register);
  }

  static void toPostCreation() {
    key.currentState?.pushNamed(NavigationRoutes.postCreate);
  }

  static void toHome() {
    key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.app, ((route) => false));
  }

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings, context) {
    switch (settings.name) {
      case NavigationRoutes.loaderWidget:
        return PageRouteBuilder(
            pageBuilder: (context, _, __) => LoaderWidget.create());
      case NavigationRoutes.auth:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => AuthWidget.create()));
      case NavigationRoutes.app:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => MainAppWidget.create()));
      case NavigationRoutes.register:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => RegisterWidget.create()));
      case NavigationRoutes.postCreate:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => PostCreateWidget.create()));
    }
    return null;
  }
}
