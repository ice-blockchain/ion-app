// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/pages/new_chat_modal/components/new_chat_initial_view/new_chat_initial_view.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class NewChatModal extends ConsumerWidget {
  const NewChatModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();

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
                Row(
                  children: [
                    Expanded(
                      child: SearchInput(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0.s),
                Row(
                  children: [
                    Expanded(
                      child: Button.compact(
                        leadingIcon: Assets.svg.iconSearchGroups.icon(
                          size: 16.0.s,
                          color: context.theme.appColors.primaryAccent,
                        ),
                        type: ButtonType.outlined,
                        onPressed: () {},
                        label: Text(
                          context.i18n.new_chat_modal_new_group_button,
                          style: context.theme.appTextThemes.body.copyWith(
                            color: context.theme.appColors.primaryText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0.s),
                    Expanded(
                      child: Button.compact(
                        leadingIcon: Assets.svg.iconSearchChannel.icon(
                          size: 16.0.s,
                          color: context.theme.appColors.primaryAccent,
                        ),
                        type: ButtonType.outlined,
                        onPressed: () {},
                        label: Text(
                          context.i18n.new_chat_modal_new_channel_button,
                          style: context.theme.appTextThemes.body.copyWith(
                            color: context.theme.appColors.primaryText,
                          ),
                        ),
                      ),
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
