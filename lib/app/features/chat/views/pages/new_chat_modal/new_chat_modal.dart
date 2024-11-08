// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/pages/new_chat_modal/components/new_chat_initial_view/new_chat_initial_view.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class NewChatModal extends StatelessWidget {
  const NewChatModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      topPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text(context.i18n.new_chat_modal_title),
            actions: [NavigationCloseButton(onPressed: () => context.pop())],
          ),
          SizedBox(height: 9.0.s),
          ScreenSideOffset.small(
            child: Column(
              children: [
                const SearchInput(
                  textInputAction: TextInputAction.search,
                ),
                SizedBox(height: 12.0.s),
                Row(
                  children: [
                    _HeaderButton(
                      icon: Assets.svg.iconSearchGroups,
                      title: context.i18n.new_chat_modal_new_group_button,
                      onTap: () {},
                    ),
                    SizedBox(width: 20.0.s),
                    _HeaderButton(
                      icon: Assets.svg.iconSearchChannel,
                      title: context.i18n.new_chat_modal_new_channel_button,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const NewChatInitialView(),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final String icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Button.compact(
        leadingIcon: icon.icon(
          size: 16.0.s,
          color: context.theme.appColors.primaryAccent,
        ),
        type: ButtonType.outlined,
        onPressed: onTap,
        label: Text(
          title,
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
      ),
    );
  }
}
