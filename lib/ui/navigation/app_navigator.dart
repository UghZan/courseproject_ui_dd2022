import 'package:courseproject_ui_dd2022/ui/widgets/auth/register.dart';
import 'package:flutter/cupertino.dart';
import '../../domain/enums/tab_item.dart';
import '../widgets/loader.dart';
import '../widgets/app.dart';
import '../widgets/auth/auth.dart';

class NavigationRoutes {
  static const loaderWidget = "/";
  static const auth = "/auth";
  static const home = "/home";
  static const register = "/register";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static final tabNavKeys = {
    TabItemEnum.home: GlobalKey<NavigatorState>(),
    TabItemEnum.search: GlobalKey<NavigatorState>(),
    TabItemEnum.newPost: GlobalKey<NavigatorState>(),
    TabItemEnum.favorites: GlobalKey<NavigatorState>(),
    TabItemEnum.profile: GlobalKey<NavigatorState>()
  };

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
        ?.pushNamedAndRemoveUntil(NavigationRoutes.home, ((route) => false));
  }

  static void toRegister() {
    key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.register, ((route) => false));
  }

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings, context) {
    switch (settings.name) {
      case NavigationRoutes.loaderWidget:
        return PageRouteBuilder(
            pageBuilder: (context, _, __) => LoaderWidget.create());
      case NavigationRoutes.auth:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => AuthWidget.create()));
      case NavigationRoutes.home:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => App.create()));
      case NavigationRoutes.register:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => RegisterWidget.create()));
    }
    return null;
  }
}
