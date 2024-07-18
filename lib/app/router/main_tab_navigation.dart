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
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_tab_navigation.g.dart';

@Riverpod(keepAlive: true)
class BottomSheetState extends _$BottomSheetState {
  @override
  Map<TabItem, bool> build() {
    return {
      for (final tab in TabItem.values)
        if (tab != TabItem.main) tab: false,
    };
  }

  void setSheetState(TabItem tab, {required bool isOpen}) {
    log('BottomSheetState - setSheetState: setting $tab to $isOpen');
    state = {...state, tab: isOpen};
  }

  void closeCurrentSheet(TabItem currentTab) {
    if (state[currentTab] ?? false) {
      log('BottomSheetState - closeCurrentSheet: '
          'closing sheet for $currentTab');
      state = {...state, currentTab: false};
    }
  }

  bool isSheetOpen(TabItem tab) {
    final isOpen = state[tab] ?? false;
    log('BottomSheetState - isSheetOpen: '
        '$tab is ${isOpen ? 'open' : 'closed'}');
    return isOpen;
  }
}

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

  TabItem _getCurrentTab() {
    final adjustedIndex = navigationShell.currentIndex;
    return TabItem.values.firstWhere(
      (tab) => tab != TabItem.main && tab.navigationIndex == adjustedIndex,
      orElse: () => TabItem.main,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomSheetState = ref.watch(bottomSheetStateProvider);
    final currentTab = _getCurrentTab();

    final isModalOpen = useState(bottomSheetState[currentTab] ?? false);

    useEffect(
      () {
        isModalOpen.value = bottomSheetState[currentTab] ?? false;
        return null;
      },
      [currentTab, bottomSheetState],
    );

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _adjustBottomNavIndex(navigationShell.currentIndex),
        onTap: (index) => _onTap(context, ref, isModalOpen, index),
        items: _navBarItems(ref),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  void _onTap(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isModalOpen,
    int index,
  ) {
    final tabItem = TabItem.values[index];
    log('_onTap: tapped on $tabItem');
    if (tabItem == TabItem.main) {
      _onMainButtonTap(context, ref, isModalOpen);
    } else {
      final bottomSheetNotifier = ref.read(bottomSheetStateProvider.notifier);
      final currentTab = _getCurrentTab();

      if (isModalOpen.value) {
        log('_onTap: closing sheet for $currentTab');
        popRoute();
        isModalOpen.value = false;
        bottomSheetNotifier.closeCurrentSheet(currentTab);
      }

      final adjustedIndex = tabItem.navigationIndex;
      log('_onTap: switching to branch $adjustedIndex');
      navigationShell.goBranch(
        adjustedIndex,
        initialLocation: true,
      );
    }
  }

  void _onMainButtonTap(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isModalOpen,
  ) {
    final currentTab = _getCurrentTab();
    log('_onMainButtonTap: current tab is $currentTab');
    final bottomSheetNotifier = ref.read(bottomSheetStateProvider.notifier);

    if (bottomSheetNotifier.isSheetOpen(currentTab)) {
      log('_onMainButtonTap: closing sheet for $currentTab');
      popRoute();
      bottomSheetNotifier.closeCurrentSheet(currentTab);
      isModalOpen.value = false;
    } else {
      log('_onMainButtonTap: opening sheet for $currentTab');
      bottomSheetNotifier.setSheetState(currentTab, isOpen: true);
      isModalOpen.value = true;
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
          // Handle main tab if needed
          break;
      }
    }
  }

  List<BottomNavigationBarItem> _navBarItems(WidgetRef ref) {
    return TabItem.values.map((tabItem) {
      if (tabItem == TabItem.main) {
        return BottomNavigationBarItem(
          icon: _MainButton(navigationShell: navigationShell),
          label: '',
        );
      }
      return BottomNavigationBarItem(
        icon: _TabIcon(
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

class _MainButton extends ConsumerWidget {
  const _MainButton({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomSheetState = ref.watch(bottomSheetStateProvider);
    final currentTab = TabItem.values.firstWhere(
      (tab) =>
          tab != TabItem.main &&
          tab.navigationIndex == navigationShell.currentIndex,
      orElse: () => TabItem.main,
    );
    final isModalOpen = bottomSheetState[currentTab] ?? false;

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
