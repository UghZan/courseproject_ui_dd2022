import 'package:courseproject_ui_dd2022/domain/enums/tab_item.dart';
import 'package:courseproject_ui_dd2022/ui/widgets/tab_home/post_detailed.dart';
import 'package:courseproject_ui_dd2022/ui/widgets/tab_profile/profile.dart';
import 'package:flutter/material.dart';

import '../../domain/models/user.dart';

class TabNavigatorRoutes {
  static const String root = "/app";
  static const String postDetails = "/app/postDetails";
  static const String userProfile = "/app/userProfile";
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  final TabItemEnum thisTab;

  const TabNavigator({Key? key, required this.navKey, required this.thisTab})
      : super(key: key);

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
          {Object? arg}) =>
      {
        TabNavigatorRoutes.root: (context) =>
            TabEnums.tabRoots[thisTab] ??
            SafeArea(
              child: Text(thisTab.name),
            ),
        TabNavigatorRoutes.postDetails: (context) => PostDetailed.create(arg),
        TabNavigatorRoutes.userProfile: (context) =>
            ProfileWidget.create(arg as User),
      };
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (settings) {
        var rb = _routeBuilders(context, arg: settings.arguments);
        if (rb.containsKey(settings.name)) {
          return MaterialPageRoute(
              builder: (context) => rb[settings.name]!(context));
        }

        return null;
      },
    );
  }
}
