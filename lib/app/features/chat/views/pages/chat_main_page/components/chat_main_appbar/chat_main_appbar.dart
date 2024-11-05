// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_edit_mode_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_text_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatMainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ChatMainAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editMode = ref.watch(conversationsEditModeProvider);

    return NavigationAppBar.screen(
      leading: NavigationTextButton(
        label: editMode ? context.i18n.core_done : context.i18n.button_edit,
        textStyle: context.theme.appTextThemes.subtitle2,
        onPressed: () {
          ref.read(conversationsEditModeProvider.notifier).editMode = !editMode;
        },
      ),
      title: GestureDetector(
        onDoubleTap: () {
          AppTestRoute().push<void>(context);
        },
        child: Text(
          context.i18n.chat_title,
          style: context.theme.appTextThemes.subtitle2,
        ),
      ),
      actions: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: Assets.svg.iconEditLink.icon(
            size: NavigationAppBar.actionButtonSide,
          ),
          onPressed: () {
            NewChatModalRoute().push<void>(context);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(NavigationAppBar.screenHeaderHeight);
}
