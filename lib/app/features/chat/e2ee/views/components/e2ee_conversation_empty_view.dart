// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/generated/assets.gen.dart';

class E2eeConversationEmptyView extends HookConsumerWidget {
  const E2eeConversationEmptyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MessagingEmptyView(
      title: context.i18n.messaging_empty_description,
      asset: Assets.svg.walletIconChatEncrypted,
      trailing: GestureDetector(
        onTap: () {
          ChatLearnMoreModalRoute().push<void>(context);
        },
        child: Text(
          context.i18n.button_learn_more,
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ),
    );
  }
}
