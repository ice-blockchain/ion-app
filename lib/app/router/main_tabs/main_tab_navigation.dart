// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/main_tabs/components/components.dart';

class MainTabNavigation extends HookWidget {
  const MainTabNavigation({
    required this.shell,
    required this.state,
    super.key,
  });

  final StatefulNavigationShell shell;
  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    final currentTab = TabItem.fromNavigationIndex(shell.currentIndex);
    final tabPressStreamController = useStreamController<TabPressSteamData>();

    return Scaffold(
      body: MainTabNavigationContainer(
        tabPressStream: tabPressStreamController.stream,
        child: shell,
      ),
      bottomNavigationBar: Container(
        decoration: state.isMainModalOpen
            ? null
            : BoxDecoration(
                boxShadow: [
                  BoxShadow(color: context.theme.appColors.darkBlue.withAlpha(14), blurRadius: 10),
                ],
              ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: context.theme.appColors.secondaryBackground,
          selectedItemColor: context.theme.appColors.primaryAccent,
          unselectedItemColor: context.theme.appColors.tertararyText,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: shell.currentIndex,
          onTap: (index) => _onTabPress(context, index, currentTab, tabPressStreamController),
          items: TabItem.values.map((tabItem) {
            return BottomNavigationBarItem(
              icon: tabItem == TabItem.main
                  ? const MainTabButton()
                  : TabIcon(
                      icon: tabItem.icon,
                      isSelected: currentTab == tabItem,
                    ),
              label: '',
            );
          }).toList(),
        ),
      ),
    );
  }

  void _onTabPress(
    BuildContext context,
    int index,
    TabItem currentTab,
    StreamController<TabPressSteamData> tabPressStream,
  ) {
    final pressedTab = TabItem.values[index];
    tabPressStream.add((current: currentTab, pressed: pressedTab));
    if (pressedTab == TabItem.main) {
      _handleMainButtonTap(context, currentTab);
    } else {
      _navigateToTab(context, pressedTab, initialLocation: currentTab == pressedTab);
    }
  }

  void _handleMainButtonTap(BuildContext context, TabItem currentTab) {
    HapticFeedback.mediumImpact();

    context.go(
      state.isMainModalOpen ? currentTab.baseRouteLocation : currentTab.mainModalLocation,
    );
  }

  void _navigateToTab(BuildContext context, TabItem tabItem, {required bool initialLocation}) =>
      state.isMainModalOpen
          ? context.go(tabItem.baseRouteLocation)
          : shell.goBranch(tabItem.navigationIndex, initialLocation: initialLocation);
}
