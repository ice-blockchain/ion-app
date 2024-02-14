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
        iconOff: Assets.images.icons.iconDappOff.path,
        iconOn: Assets.images.icons.iconDappOn.path,
      ),
    ),
    NavigationDestination(
      label: 'Chat2',
      icon: TabIcon(
        currentIndex: navigationShell.currentIndex,
        tabIndex: 1,
        iconOff: Assets.images.icons.iconChatOff.path,
        iconOn: Assets.images.icons.iconChatOn.path,
      ),
    ),
    NavigationDestination(
      label: 'Wallet',
      icon: TabIcon(
        currentIndex: navigationShell.currentIndex,
        tabIndex: 2,
        iconOff: Assets.images.icons.iconButtonManageWallet.path,
        iconOn: Assets.images.icons.iconButtonManageWallet.path,
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

    final int defaultTabIndex = destinations.indexWhere(
      (NavigationDestination destination) => destination.label == 'DApps',
    );

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: defaultTabIndex,
        destinations: destinations,
        backgroundColor: Colors.white,
        onDestinationSelected: _goBranch,
        indicatorColor: Colors.transparent,
      ),
    );
  }
}
