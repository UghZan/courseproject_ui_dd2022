import 'package:courseproject_ui_dd2022/ui/pages/app.dart';
import 'package:courseproject_ui_dd2022/ui/pages/auth.dart';
import 'package:courseproject_ui_dd2022/ui/pages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:courseproject_ui_dd2022/ui/pages/loader.dart';

import '../domain/models/user.dart';

class NavigationRoutes {
  static const loaderWidget = "/";
  static const auth = "/auth";
  static const app = "/app";
  static const profile = "/profile";
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

  static void toHome() {
    key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.app, ((route) => false));
  }

  static void toProfile(User user) {
    key.currentState?.pushNamed(NavigationRoutes.profile, arguments: user);
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
      case NavigationRoutes.profile:
        return PageRouteBuilder(
            opaque: false,
            pageBuilder: ((_, __, ___) =>
                ProfileWidget.create(settings.arguments as User)));
    }
    return null;
  }
}
