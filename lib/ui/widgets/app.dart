// ignore_for_file: depend_on_referenced_packages
import 'package:courseproject_ui_dd2022/domain/enums/tab_item.dart';
import 'package:courseproject_ui_dd2022/ui/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../../domain/models/user.dart';
import '../../internal/app_config.dart';
import '../../internal/shared_prefs.dart';
import '../navigation/tab_navigator.dart';
import 'common/bottom_tab.dart';

class AppViewModel extends ChangeNotifier {
  BuildContext context;
  AppViewModel({required this.context}) {
    asyncInit();
  }

  var _currentTab = TabEnums.defTab;
  TabItemEnum? prevTab;
  TabItemEnum get currentTab => _currentTab;
  void selectTab(TabItemEnum tabItemEnum) {
    if (tabItemEnum == _currentTab) {
      AppNavigator.tabNavKeys[tabItemEnum]!.currentState!
          .popUntil((route) => route.isFirst);
      notifyListeners();
    } else {
      prevTab = _currentTab;
      _currentTab = tabItemEnum;
      notifyListeners();
    }
  }

  String? _msg;
  String? get msg => _msg;
  set msg(String? val) {
    _msg = val;
    if (val != null) {
      showSnackBar(val);
    }
    notifyListeners();
  }

  User? _user;
  User? get user => _user;
  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  Image? _userAvatar;
  Image? get avatar => _userAvatar;
  set avatar(Image? val) {
    _userAvatar = val;
    notifyListeners();
  }

  void setAvatar(Image newAvatar) {
    avatar = newAvatar;
  }

  void asyncInit() async {
    user = await SharedPrefs.getStoredUser();
    if (user!.linkToAvatar != null) {
      var img =
          await NetworkAssetBundle(Uri.parse("$baseUrl${user!.linkToAvatar}"))
              .load("$baseUrl${user!.linkToAvatar}?v=1");
      avatar = Image.memory(
        img.buffer.asUint8List(),
        fit: BoxFit.fill,
      );
    }
  }

  showSnackBar(String text) {
    var sb = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(sb);
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AppViewModel>();

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
            child: Scaffold(
              bottomNavigationBar: BottomTabs(
                currentTab: viewModel.currentTab,
                onSelectTab: (tab) => viewModel.selectTab(tab),
              ),
              body: Stack(
                  children: TabItemEnum.values
                      .map((e) => _buildOffstageNavigator(context, e))
                      .toList()),
            ),
            onWillPop: () async {
              return Future.value(false);
            }));
  }

  static create() {
    return ChangeNotifierProvider(
        create: (context) => AppViewModel(context: context),
        child: const App());
  }

  Widget _buildOffstageNavigator(BuildContext context, TabItemEnum tabItem) {
    var viewModel = context.watch<AppViewModel>();

    return Offstage(
      offstage: viewModel.currentTab != tabItem,
      child: TabNavigator(
        navKey: AppNavigator.tabNavKeys[tabItem]!,
        thisTab: tabItem,
      ),
    );
  }
}
