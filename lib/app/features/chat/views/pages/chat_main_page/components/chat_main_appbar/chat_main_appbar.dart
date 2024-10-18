// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_text_button.dart';
import 'package:ice/generated/assets.gen.dart';

class ChatMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatMainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationAppBar.screen(
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(NavigationAppBar.screenHeaderHeight);
}
