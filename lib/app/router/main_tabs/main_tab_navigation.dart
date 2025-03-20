// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/user_chat_relays_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_edit_mode_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/conversation_edit_bottom_bar/conversation_edit_bottom_bar.dart';
import 'package:ion/app/features/chat/views/components/unread_messages_counter.dart';
import 'package:ion/app/hooks/use_on_init.dart';
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
    final tabHistory = useState<List<int>>([shell.currentIndex]);
    final tabPressStreamController = useStreamController<TabPressSteamData>();
    final currentTab = TabItem.fromNavigationIndex(shell.currentIndex);

    useOnInit(() {
      ref.read(userChatRelaysManagerProvider.notifier).sync();
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          if (Navigator.of(ref.context).canPop()) {
            context.pop();
          } else {
            if (tabHistory.value.length > 1) {
              tabHistory.value = List.from(tabHistory.value)..removeLast();
              final previousIndex = tabHistory.value.last;
              shell.goBranch(previousIndex);
            }
          }
        }
      },
      child: Scaffold(
        body: MainTabNavigationContainer(
          tabPressStream: tabPressStreamController.stream,
          child: shell,
        ),
        bottomNavigationBar: state.shouldHideBottomBar
            ? null
            : _BottomNavBarContent(
                state: state,
                currentTab: currentTab,
                onTabPressed: (TabItem tabItem) {
                  final newIndex = tabItem.navigationIndex;
                  if (tabHistory.value.last != newIndex) {
                    tabHistory.value = List.from(tabHistory.value)..add(newIndex);
                  }

                  tabPressStreamController.add((current: currentTab, pressed: tabItem));
                  if (tabItem == TabItem.main) {
                    _handleMainButtonTap(context, currentTab);
                  } else {
                    _navigateToTab(context, tabItem, initialLocation: currentTab == tabItem);
                  }
                },
              ),
      ),
    );
  }

  void _handleMainButtonTap(BuildContext context, TabItem currentTab) {
    HapticFeedback.mediumImpact();

    if (state.isMainModalOpen) {
      context.pop();
    } else {
      context.push(currentTab.mainModalLocation);
    }
  }

  void _navigateToTab(BuildContext context, TabItem tabItem, {required bool initialLocation}) {
    if (state.isMainModalOpen) {
      context.pop();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => shell.goBranch(tabItem.navigationIndex),
      );
    } else {
      shell.goBranch(tabItem.navigationIndex, initialLocation: initialLocation);
    }
  }
}

class _BottomNavBarContent extends ConsumerWidget {
  const _BottomNavBarContent({
    required this.state,
    required this.currentTab,
    required this.onTabPressed,
  });

  final GoRouterState state;
  final TabItem currentTab;
  final ValueChanged<TabItem> onTabPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsEditMode = ref.watch(conversationsEditModeProvider);

    return Stack(
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
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: TabItem.values.map((tabItem) {
                final isSelected = currentTab == tabItem;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTabPressed(tabItem),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 9.0.s),
                      color: context.theme.appColors.secondaryBackground,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          tabItem.getIcon(isSelected: isSelected),
                          if (tabItem == TabItem.chat) const UnreadMessagesCounter(),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        if (conversationsEditMode && currentTab == TabItem.chat) const ConversationEditBottomBar(),
      ],
    );
  }
}
