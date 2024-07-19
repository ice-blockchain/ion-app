import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/main_tabs/components/components.dart';

class MainTabNavigation extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _adjustBottomNavIndex(navigationShell.currentIndex),
        onTap: (index) => _onTabSelected(context, ref, index),
        items: _navBarItems(ref),
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.theme.appColors.secondaryBackground,
        selectedItemColor: context.theme.appColors.primaryAccent,
        unselectedItemColor: context.theme.appColors.tertararyText,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  void _onTabSelected(BuildContext context, WidgetRef ref, int index) {
    final tabItem = TabItem.values[index];
    if (tabItem == TabItem.main) {
      _handleMainButtonTap(context, ref);
    } else {
      _navigateToTab(context, ref, tabItem);
    }
  }

  void _navigateToTab(BuildContext context, WidgetRef ref, TabItem tabItem) {
    final bottomSheetNotifier = ref.read(bottomSheetStateProvider.notifier);
    final currentTab = _getCurrentTab();

    if (bottomSheetNotifier.isSheetOpen(currentTab)) {
      context.pop();
      bottomSheetNotifier.closeCurrentSheet(currentTab);
    }

    final adjustedIndex = tabItem.navigationIndex;
    navigationShell.goBranch(
      adjustedIndex,
      initialLocation: true,
    );
  }

  void _handleMainButtonTap(BuildContext context, WidgetRef ref) {
    final currentTab = _getCurrentTab();
    final bottomSheetNotifier = ref.read(bottomSheetStateProvider.notifier);

    if (bottomSheetNotifier.isSheetOpen(currentTab)) {
      context.pop();
      bottomSheetNotifier.closeCurrentSheet(currentTab);
    } else {
      bottomSheetNotifier.setSheetState(currentTab, isOpen: true);
      _openMainModalForCurrentTab(context, currentTab);
    }
  }

  void _openMainModalForCurrentTab(BuildContext context, TabItem currentTab) {
    switch (currentTab) {
      case TabItem.feed:
        FeedMainModalRoute().go(context);
      case TabItem.chat:
        ChatMainModalRoute().go(context);
      case TabItem.dapps:
        DappsMainModalRoute().go(context);
      case TabItem.wallet:
        WalletMainModalRoute().go(context);
      case TabItem.main:
        break;
    }
  }

  List<BottomNavigationBarItem> _navBarItems(WidgetRef ref) {
    return TabItem.values.map((tabItem) {
      if (tabItem == TabItem.main) {
        return BottomNavigationBarItem(
          icon: MainTabButton(
            navigationShell: navigationShell,
            currentTab: _getCurrentTab,
          ),
          label: '',
        );
      }
      return BottomNavigationBarItem(
        icon: TabIcon(
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
