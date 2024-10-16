// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/chat/views/components/chat_empty_view.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_text_button.dart';
import 'package:ice/generated/assets.gen.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationAppBar.screen(
        leading: NavigationTextButton(
          label: context.i18n.button_edit,
          textStyle: context.theme.appTextThemes.subtitle2,
          onPressed: () {},
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
            icon: Assets.svg.iconEditLink.icon(
              size: NavigationAppBar.actionButtonSide,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ScreenSideOffset.small(
        child: const Column(
          children: [
            SearchInput(),
            ChatEmptyView(),
          ],
        ),
      ),
    );
  }
}
