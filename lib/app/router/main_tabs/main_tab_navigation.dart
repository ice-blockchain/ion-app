import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/main_tabs/components/components.dart';

class MainTabNavigation extends StatelessWidget {
  const MainTabNavigation({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  TabItem _getCurrentTab() =>
      TabItem.fromNavigationIndex(navigationShell.currentIndex);

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

    context.go(
      isModalOpen(context)
          ? currentTab.baseRouteLocation
          : currentTab.mainModalLocation,
    );
  }

  bool isModalOpen(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    return TabItem.isMainModalOpen(currentLocation);
  }

  void _navigateToTab(BuildContext context, TabItem tabItem) {
    final isCurrentTab = _getCurrentTab() == tabItem;

    if (isModalOpen(context)) {
      context.go(tabItem.baseRouteLocation);
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
