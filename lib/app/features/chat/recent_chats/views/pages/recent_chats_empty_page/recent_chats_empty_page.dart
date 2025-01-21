// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class RecentChatsEmptyPage extends ConsumerWidget {
  const RecentChatsEmptyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => ChatSimpleSearchRoute().push<void>(context),
          child: const IgnorePointer(
            child: SearchInput(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 210.0.s),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.svg.walletChatEmptystate.icon(
                size: 48.0.s,
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0.s),
                child: Text(
                  context.i18n.chat_empty_description,
                  style: context.theme.appTextThemes.caption2.copyWith(
                    color: context.theme.appColors.onTertararyBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                onPressed: () {
                  NewChatModalRoute().push<void>(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(UiConstants.hitSlop),
                  child: Text(
                    context.i18n.chat_new_message_button,
                    style: context.theme.appTextThemes.caption
                        .copyWith(color: context.theme.appColors.primaryAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
