// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/conversation_type.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/main_modal_item.dart';
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
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const HorizontalSeparator(),
            itemCount: menuItems.length,
            itemBuilder: (BuildContext context, int index) {
              final type = menuItems[index];

              return MainModalItem(
                item: type,
                onTap: () {
                  context
                    ..go(GoRouterState.of(context).currentTab.baseRouteLocation)
                    ..go(NewChatModalRoute().location);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
