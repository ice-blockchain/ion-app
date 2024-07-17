import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/app_routes.dart';
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
      TabItem.main => Assets.images.logo.logoButton,
      TabItem.dapps => Assets.images.icons.iconDappOff,
      TabItem.wallet => Assets.images.icons.iconsWalletOff
    };
  }

  int get navigationIndex => index > TabItem.main.index ? index - 1 : index;
}

class MainTabNavigation extends HookConsumerWidget {
  const MainTabNavigation({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isModalOpen = useState(false);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.canPop()) {
            isModalOpen.value = true;
          }
        });
        return null;
      },
      [],
    );

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Builder(
        builder: (context) {
          log('Rebuilding BottomNavigationBar, '
              'isModalOpen: ${isModalOpen.value}');
          return BottomNavigationBar(
            currentIndex: _adjustBottomNavIndex(navigationShell.currentIndex),
            onTap: (index) => _onTap(context, isModalOpen, index),
            items:
                _navBarItems(isModalOpen.value, navigationShell.currentIndex),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurface,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          );
        },
      ),
    );
  }

  void _onTap(
    BuildContext context,
    ValueNotifier<bool> isModalOpen,
    int index,
  ) {
    final tabItem = TabItem.values[index];
    if (tabItem == TabItem.main) {
      _onMainButtonTap(context, isModalOpen);
    } else {
      if (isModalOpen.value) {
        context.pop();
        isModalOpen.value = false;
      }

      final adjustedIndex = tabItem.navigationIndex;
      navigationShell.goBranch(
        adjustedIndex,
        initialLocation: adjustedIndex == navigationShell.currentIndex,
      );
    }
  }

  void _onMainButtonTap(BuildContext context, ValueNotifier<bool> isModalOpen) {
    if (context.canPop()) {
      context.pop();
      isModalOpen.value = false;
    } else {
      final currentIndex = navigationShell.currentIndex;
      final currentTab = TabItem.values.firstWhere(
        (tab) => tab != TabItem.main && tab.navigationIndex == currentIndex,
        orElse: () => TabItem.main,
      );

      switch (currentTab) {
        case TabItem.feed:
          FeedMainModalRoute().push<void>(context);
        case TabItem.chat:
          ChatMainModalRoute().push<void>(context);
        case TabItem.dapps:
          DappsMainModalRoute().push<void>(context);
        case TabItem.wallet:
          WalletMainModalRoute().push<void>(context);
        case TabItem.main:
          // Handle main tab if needed
          break;
      }
      isModalOpen.value = true;
    }
  }

  List<BottomNavigationBarItem> _navBarItems(
    bool isModalOpen,
    int currentIndex,
  ) {
    return TabItem.values.map((tabItem) {
      if (tabItem == TabItem.main) {
        return BottomNavigationBarItem(
          icon: _MainButton(isModalOpen: isModalOpen),
          label: '',
        );
      }
      return BottomNavigationBarItem(
        icon: _TabIcon(
          icon: tabItem.icon!,
          isSelected: currentIndex == tabItem.navigationIndex,
        ),
        label: '',
      );
    }).toList();
  }

  int _adjustBottomNavIndex(int index) =>
      index >= TabItem.main.index ? index + 1 : index;
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
  const _MainButton({required this.isModalOpen});

  final bool isModalOpen;

  @override
  Widget build(BuildContext context) {
    log('_MainButton build, isModalOpen: $isModalOpen');
    final icon = isModalOpen
        ? Assets.images.logo.logoButtonClose
        : Assets.images.logo.logoButton;

    return SizedBox(
      width: 50,
      height: 50,
      child: icon.image(fit: BoxFit.contain),
    );
  }
}
