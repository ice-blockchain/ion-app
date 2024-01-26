import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/router/views/tab_icon.dart';
import 'package:ice/generated/assets.gen.dart';

List<NavigationDestination> getDestinations(
  StatefulNavigationShell navigationShell,
) {
  return <NavigationDestination>[
    NavigationDestination(
      label: 'DApps',
      icon: TabIcon(
        currentIndex: navigationShell.currentIndex,
        tabIndex: 0,
        iconOff: Assets.images.itemDappConditionOff.path,
        iconOn: Assets.images.itemDappConditionOn.path,
      ),
    ),
    NavigationDestination(
      label: 'Chat2',
      icon: TabIcon(
        currentIndex: navigationShell.currentIndex,
        tabIndex: 1,
        iconOff: Assets.images.itemChatConditionOff.path,
        iconOn: Assets.images.itemChatConditionOn.path,
      ),
    ),
    NavigationDestination(
      label: 'Wallet',
      icon: TabIcon(
        currentIndex: navigationShell.currentIndex,
        tabIndex: 2,
        iconOff: Assets.images.itemWalletConditionOff.path,
        iconOn: Assets.images.itemWalletConditionOn.path,
      ),
    ),
  ];
}

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
          key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'),
        );
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<NavigationDestination> destinations =
        getDestinations(navigationShell);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: navigationShell.currentIndex,
        destinations: destinations,
        backgroundColor: Colors.white,
        onDestinationSelected: _goBranch,
        indicatorColor: Colors.transparent,
      ),
    );
  }
}
