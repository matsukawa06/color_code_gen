import 'package:color_code_gen/common/common_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final _navigatorKeys = <TabItem, GlobalKey<NavigatorState>>{
  TabItem.search: GlobalKey<NavigatorState>(),
  TabItem.favorit: GlobalKey<NavigatorState>(),
  TabItem.setting: GlobalKey<NavigatorState>(),
};

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // useState でタブの選択状態を管理
    final currentTab = useState(TabItem.search);
    return Scaffold(
      body: Stack(
        children: TabItem.values
            .map(
              (tabItem) => Offstage(
                offstage: currentTab.value != tabItem,
                // 各ページのNavigatorにNavigatorStateを持ったKeyを渡す
                child: Navigator(
                  key: _navigatorKeys[tabItem],
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute<Widget>(
                      builder: (context) => tabItem.page,
                    );
                  },
                ),
              ),
            )
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: TabItem.values.indexOf(currentTab.value),
        selectedItemColor: Colors.amber[800],
        items: TabItem.values
            .map(
              (tabItem) => BottomNavigationBarItem(
                icon: Icon(tabItem.icon),
                label: tabItem.title,
              ),
            )
            .toList(),
        onTap: (index) {
          // 選択済みなら第一階層まで pop / 未選択なら currentTab に指定
          final selectedTab = TabItem.values[index];
          if (currentTab.value == selectedTab) {
            _navigatorKeys[selectedTab]?.currentState?.popUntil((route) => route.isFirst);
          } else {
            currentTab.value = selectedTab;
          }
        },
      ),
    );
  }
}
