// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/models/conversation_type.dart';
import 'package:ion/app/features/feed/views/pages/feed_main_modal/components/feed_modal_item.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class ChatMainModalPage extends StatelessWidget {
  const ChatMainModalPage({super.key});

  static const List<ConversationType> menuItems = ConversationType.values;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.screen(
            title: Text(context.i18n.chat_modal_title),
            showBackButton: false,
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, __) => const HorizontalSeparator(),
            itemCount: menuItems.length,
            itemBuilder: (BuildContext context, int index) {
              final type = menuItems[index];

              return FeedModalItem(
                feedType: type,
                onTap: () {
                  final createFlowRouteLocation = _getCreateFlowRouteLocation(type);
                  context
                    ..go(GoRouterState.of(context).currentTab.baseRouteLocation)
                    ..go(createFlowRouteLocation);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _getCreateFlowRouteLocation(ConversationType type) {
    return switch (type) {
      ConversationType.private => DeleteConversationRoute(conversationId: '1').location,
      ConversationType.group => DeleteConversationRoute(conversationId: '2').location,
      ConversationType.channel => DeleteConversationRoute(conversationId: '3').location,
    };
  }
}
