import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/views/tab_icon.dart';
import 'package:ice/generated/assets.gen.dart';

List<NavigationDestination> getDestinations(
  StatefulNavigationShell navigationShell,
  BuildContext context,
) {
  return <NavigationDestination>[
    NavigationDestination(
      label: 'Feed',
      icon: TabIcon(
        currentIndex: navigationShell.currentIndex,
        tabIndex: 0,
        iconOff: Image.asset(
          Assets.images.icons.iconHomeOff.path,
          color: context.theme.appColors.tertararyText,
        ),
        iconOn: Image.asset(
          Assets.images.icons.iconHomeOff.path,
          color: context.theme.appColors.primaryAccent,
        ),
      ),
    ),
    NavigationDestination(
      label: 'Dapp',
      icon: TabIcon(
        currentIndex: navigationShell.currentIndex,
        tabIndex: 1,
        iconOff: Image.asset(
          Assets.images.icons.iconDappOff.path,
          color: context.theme.appColors.tertararyText,
        ),
        iconOn: Image.asset(
          Assets.images.icons.iconDappOff.path,
          color: context.theme.appColors.primaryAccent,
        ),
      ),
    ),
    NavigationDestination(
      label: 'Chat2',
      icon: TabIcon(
        currentIndex: navigationShell.currentIndex,
        tabIndex: 2,
        iconOff: Image.asset(
          Assets.images.icons.iconChatOff.path,
          color: context.theme.appColors.tertararyText,
        ),
        iconOn: Image.asset(
          Assets.images.icons.iconChatOff.path,
          color: context.theme.appColors.primaryAccent,
        ),
      ),
    ),
    NavigationDestination(
      label: 'Wallet',
      icon: TabIcon(
        currentIndex: navigationShell.currentIndex,
        tabIndex: 3,
        iconOff: Image.asset(
          Assets.images.icons.iconButtonManageWallet.path,
          color: context.theme.appColors.tertararyText,
        ),
        iconOn: Image.asset(
          Assets.images.icons.iconButtonManageWallet.path,
          color: context.theme.appColors.primaryAccent,
        ),
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
    final List<NavigationDestination> destinations = getDestinations(
      navigationShell,
      context,
    );

    final int defaultTabIndex = destinations.indexWhere(
      (NavigationDestination destination) => destination.label == 'Feed',
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
