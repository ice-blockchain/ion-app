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
    final currentIndex = navigationShell.currentIndex;
    return _navigationIndexToTab[currentIndex] ?? TabItem.main;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
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

  void _handleMainButtonTap(BuildContext context) {
    final currentTab = _getCurrentTab();
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final isModalOpen = isMainModalOpen(currentLocation);

    context.go(
      isModalOpen
          ? getBaseRouteLocation(currentTab)
          : getMainModalLocation(currentTab),
    );
  }

  void _navigateToTab(BuildContext context, TabItem tabItem) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final isCurrentTab = _getCurrentTab() == tabItem;
    final isModalOpen = isMainModalOpen(currentLocation);

    if (isModalOpen) {
      context.go(getBaseRouteLocation(tabItem));
    }

    if (!isCurrentTab) {
      navigationShell.goBranch(
        tabItem.navigationIndex,
        initialLocation: true,
      );
    }
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
}
