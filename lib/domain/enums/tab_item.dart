import 'package:courseproject_ui_dd2022/ui/widgets/tab_post/post_creation.dart';
import 'package:courseproject_ui_dd2022/ui/widgets/tab_home/home.dart';
import 'package:courseproject_ui_dd2022/ui/widgets/tab_profile/profile.dart';
import 'package:flutter/material.dart';

enum TabItemEnum { home, search, newPost, favorites, profile }

class TabEnums {
  static const TabItemEnum defTab = TabItemEnum.home;

  static Map<TabItemEnum, IconData> tabIcon = {
    TabItemEnum.home: Icons.home_outlined,
    TabItemEnum.search: Icons.search_outlined,
    TabItemEnum.newPost: Icons.add_box_outlined,
    TabItemEnum.favorites: Icons.favorite_outline,
    TabItemEnum.profile: Icons.person_outline
  };

  static Map<TabItemEnum, Widget> tabRoots = {
    TabItemEnum.home: HomeWidget.create(),
    TabItemEnum.profile: ProfileWidget.create(null),
    TabItemEnum.newPost: PostCreateWidget.create()
  };
}
