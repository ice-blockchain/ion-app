import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

enum TabItem {
  feed,
  chat,
  main,
  dapps,
  wallet;

  const TabItem();

  AssetGenImage? get icon {
    return switch (this) {
      TabItem.feed => Assets.images.icons.iconHomeOff,
      TabItem.chat => Assets.images.icons.iconChatOff,
      TabItem.main => null,
      TabItem.dapps => Assets.images.icons.iconDappOff,
      TabItem.wallet => Assets.images.icons.iconsWalletOff
    };
  }

  int get navigationIndex => index > TabItem.main.index ? index - 1 : index;
}

class MainTabNavigation extends StatelessWidget {
  const MainTabNavigation({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    final tabItem = TabItem.values[index];
    if (tabItem == TabItem.main) {
      _onMainButtonTap();
      return;
    }

    final adjustedIndex = tabItem.navigationIndex;

    navigationShell.goBranch(
      adjustedIndex,
      initialLocation: adjustedIndex == navigationShell.currentIndex,
    );
  }

  void _onMainButtonTap() {
    log('MainTabNavigation: Main button tapped');
  }

  int _adjustBottomNavIndex(int index) =>
      index >= TabItem.main.index ? index + 1 : index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _adjustBottomNavIndex(navigationShell.currentIndex),
        onTap: _onTap,
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

  List<BottomNavigationBarItem> _navBarItems() {
    return TabItem.values.map((tabItem) {
      if (tabItem == TabItem.main) {
        return const BottomNavigationBarItem(
          icon: _MainButton(),
          label: '',
        );
      }
      return BottomNavigationBarItem(
        icon: _TabIcon(
          icon: tabItem.icon!,
          isSelected: _isTabSelected(tabItem),
        ),
        label: '',
      );
    }).toList();
  }

  bool _isTabSelected(TabItem tabItem) {
    return navigationShell.currentIndex == tabItem.navigationIndex;
  }
}

class _TabIcon extends StatelessWidget {
  const _TabIcon({
    required this.icon,
    required this.isSelected,
  });

  final AssetGenImage icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return icon.image(
      width: 24.0.s,
      height: 24.0.s,
      color: isSelected
          ? context.theme.appColors.primaryAccent
          : context.theme.appColors.tertararyText,
    );
  }
}

class _MainButton extends StatelessWidget {
  const _MainButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.0.s,
      height: 50.0.s,
      child: Assets.images.logo.logoButton.image(
        fit: BoxFit.contain,
      ),
    );
  }
}
