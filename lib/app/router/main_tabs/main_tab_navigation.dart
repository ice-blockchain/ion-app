// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_edit_mode_provider.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/conversation_edit_bottom_bar/conversation_edit_bottom_bar.dart';
import 'package:ion/app/router/main_tabs/components/components.dart';

class MainTabNavigation extends HookConsumerWidget {
  const MainTabNavigation({
    required this.shell,
    required this.state,
    super.key,
  });

  final StatefulNavigationShell shell;
  final GoRouterState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabPressStreamController = useStreamController<TabPressSteamData>();
    final currentTab = TabItem.fromNavigationIndex(shell.currentIndex);
    final conversationsEditMode = ref.watch(conversationsEditModeProvider);

    return Scaffold(
      body: MainTabNavigationContainer(
        tabPressStream: tabPressStreamController.stream,
        child: shell,
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.theme.appColors.secondaryBackground,
              boxShadow: state.isMainModalOpen
                  ? null
                  : [
                      BoxShadow(
                        color: context.theme.appColors.darkBlue.withAlpha(14),
                        blurRadius: 10,
                      ),
                    ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: TabItem.values.map((tabItem) {
                final isSelected = currentTab == tabItem;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        _onTabPress(context, tabItem.index, currentTab, tabPressStreamController),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 9.0.s,
                        // Adding extra padding to the bottom of the tab bar if the device has a bottom padding
                        bottom: MediaQuery.of(context).padding.bottom > 0 ? 23.0.s : 9.0.s,
                      ),
                      color: context.theme.appColors.secondaryBackground,
                      child: _getTabButton(tabItem, isSelected),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (conversationsEditMode && currentTab == TabItem.chat)
            const ConversationEditBottomBar(),
        ],
      ),
    );
  }

  Widget _getTabButton(TabItem tabItem, bool isSelected) {
    return tabItem == TabItem.main
        ? const MainTabButton()
        : TabIcon(
            icon: tabItem.icon,
            isSelected: isSelected,
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
