import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final List<Widget> destinations = <Widget>[
  const NavigationDestination(label: 'Wallet', icon: Icon(Icons.wallet)),
  const NavigationDestination(label: 'Chat2', icon: Icon(Icons.chat)),
];

final class ScaffoldWithNestedNavigation extends StatelessWidget {
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
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
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

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.chat);
  }
}
