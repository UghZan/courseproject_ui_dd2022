import 'package:courseproject_ui_dd2022/domain/enums/tab_item.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatelessWidget {
  final TabItemEnum currentTab;
  final ValueChanged<TabItemEnum> onSelectTab;
  const BottomTabs(
      {Key? key, required this.currentTab, required this.onSelectTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: TabItemEnum.values.indexOf(currentTab),
      items: TabItemEnum.values.map((e) => _buildItem(e)).toList(),
      onTap: (value) {
        FocusScope.of(context).unfocus();
        onSelectTab(TabItemEnum.values[value]);
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItemEnum tabItem) {
    var isSelected = currentTab == tabItem;
    var color = isSelected ? Colors.grey[600] : Colors.grey[400];
    var icon = Icon(TabEnums.tabIcon[tabItem], color: color);

    return BottomNavigationBarItem(label: "", icon: icon);
  }
}
