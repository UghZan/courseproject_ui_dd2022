import 'package:flutter/material.dart';

enum TabItemEnum { home, search, newPost, profile }

class TabEnums {
  static const TabItemEnum defTab = TabItemEnum.home;

  static Map<TabItemEnum, IconData> tabIcon = {
    TabItemEnum.home: Icons.home_outlined,
    TabItemEnum.search: Icons.search_outlined,
    TabItemEnum.newPost: Icons.add_box_outlined,
    TabItemEnum.profile: Icons.person_outline
  };
}
