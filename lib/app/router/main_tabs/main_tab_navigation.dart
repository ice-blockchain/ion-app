import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/main_tabs/components/components.dart';
import 'package:ice/app/router/utils/go_router_state_extensions.dart';

class MainTabNavigation extends StatelessWidget {
  const MainTabNavigation({
    required this.navigationShell,
    required this.state,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    final currentTab =
        TabItem.fromNavigationIndex(navigationShell.currentIndex);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTabSelected(context, index, currentTab),
        items: _navBarItems(currentTab),
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.theme.appColors.secondaryBackground,
        selectedItemColor: context.theme.appColors.primaryAccent,
        unselectedItemColor: context.theme.appColors.tertararyText,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  void _onTabSelected(BuildContext context, int index, TabItem currentTab) {
    final tabItem = TabItem.values[index];
    if (tabItem == TabItem.main) {
      _handleMainButtonTap(context, currentTab);
    } else if (currentTab != tabItem) {
      _navigateToTab(context, tabItem);
    }
  }

  void _handleMainButtonTap(BuildContext context, TabItem currentTab) =>
      context.go(
        state.isMainModalOpen
            ? currentTab.baseRouteLocation
            : currentTab.mainModalLocation,
      );

  void _navigateToTab(BuildContext context, TabItem tabItem) =>
      state.isMainModalOpen
          ? context.go(tabItem.baseRouteLocation)
          : navigationShell.goBranch(
              tabItem.navigationIndex,
              initialLocation: true,
            );

  List<BottomNavigationBarItem> _navBarItems(TabItem currentTab) {
    return TabItem.values.map((tabItem) {
      return BottomNavigationBarItem(
        icon: tabItem == TabItem.main
            ? const MainTabButton()
            : TabIcon(
                icon: tabItem.icon!,
                isSelected: currentTab == tabItem,
              ),
        label: '',
      );
    }).toList();
  }
}
