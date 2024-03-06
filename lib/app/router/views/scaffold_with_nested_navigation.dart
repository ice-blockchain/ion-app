import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
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
        iconOff: Assets.images.icons.iconHomeOff.icon(
          color: context.theme.appColors.tertararyText,
        ),
        iconOn: Assets.images.icons.iconHomeOff.icon(
          color: context.theme.appColors.primaryAccent,
        ),
      ),
    ),
    NavigationDestination(
      label: 'Dapp',
      icon: TabIcon(
        currentIndex: navigationShell.currentIndex,
        tabIndex: 1,
        iconOff: Assets.images.icons.iconDappOff.icon(
          color: context.theme.appColors.tertararyText,
        ),
        iconOn: Assets.images.icons.iconDappOff.icon(
          color: context.theme.appColors.primaryAccent,
        ),
      ),
    ),
    NavigationDestination(
      label: 'Chat2',
      icon: TabIcon(
        currentIndex: navigationShell.currentIndex,
        tabIndex: 2,
        iconOff: Assets.images.icons.iconChatOff.icon(
          color: context.theme.appColors.tertararyText,
        ),
        iconOn: Assets.images.icons.iconChatOff.icon(
          color: context.theme.appColors.primaryAccent,
        ),
      ),
    ),
    NavigationDestination(
      label: 'PullRightMenu',
      icon: TabIcon(
        currentIndex: navigationShell.currentIndex,
        tabIndex: 3,
        iconOff: Assets.images.icons.iconButtonManageWallet.icon(
          color: context.theme.appColors.tertararyText,
        ),
        iconOn: Assets.images.icons.iconButtonManageWallet.icon(
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
