import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/main_tabs/components/components.dart';
import 'package:ice/app/router/utils/route_utils.dart';

class MainTabNavigation extends StatelessWidget {
  const MainTabNavigation({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  static final Map<int, TabItem> _navigationIndexToTab = {
    for (var tab in TabItem.values)
      if (tab != TabItem.main) tab.navigationIndex: tab,
  };

  TabItem _getCurrentTab() {
    final adjustedIndex = navigationShell.currentIndex;
    return _navigationIndexToTab[adjustedIndex] ?? TabItem.main;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _adjustBottomNavIndex(navigationShell.currentIndex),
        onTap: (index) => _onTabSelected(context, index),
        items: _navBarItems(),
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.theme.appColors.secondaryBackground,
        selectedItemColor: context.theme.appColors.primaryAccent,
        unselectedItemColor: context.theme.appColors.tertararyText,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  void _onTabSelected(BuildContext context, int index) {
    final tabItem = TabItem.values[index];
    tabItem == TabItem.main
        ? _handleMainButtonTap(context)
        : _navigateToTab(context, tabItem);
  }

  void _navigateToTab(BuildContext context, TabItem tabItem) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final isCurrentTab = _getCurrentTab() == tabItem;
    final isModalOpen = isMainModalOpen(currentLocation);

    if (isCurrentTab) {
      final targetLocation = isModalOpen
          ? getBaseRouteLocation(tabItem)
          : getMainModalLocation(tabItem);
      context.go(targetLocation);
    } else {
      if (isModalOpen) {
        context.go(getBaseRouteLocation(tabItem));
      }
      _goToBranch(tabItem);
    }
  }

  void _goToBranch(TabItem tabItem) {
    navigationShell.goBranch(
      tabItem.navigationIndex,
      initialLocation: true,
    );
  }

  void _handleMainButtonTap(BuildContext context) {
    final currentTab = _getCurrentTab();
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final isModalOpen = isMainModalOpen(currentLocation);

    final targetLocation = isModalOpen
        ? getBaseRouteLocation(currentTab)
        : getMainModalLocation(currentTab);

    context.go(targetLocation);
  }

  List<BottomNavigationBarItem> _navBarItems() {
    return TabItem.values.map((tabItem) {
      return BottomNavigationBarItem(
        icon: tabItem == TabItem.main
            ? MainTabButton(
                navigationShell: navigationShell,
                currentTab: _getCurrentTab,
              )
            : TabIcon(
                icon: tabItem.icon!,
                isSelected: _getCurrentTab() == tabItem,
              ),
        label: '',
      );
    }).toList();
  }

  int _adjustBottomNavIndex(int index) =>
      index >= TabItem.main.index ? index + 1 : index;
}
