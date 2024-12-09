// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/messages/providers/chat_messages_provider.c.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/views/components/messages_list.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/keyboard/keyboard.dart';
import 'package:ion/generated/assets.gen.dart';

const String hasPrivacyModalShownKey = 'hasPrivacyModalShownKey';

class MessagesPage extends HookConsumerWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = useMemoized(() => Random().nextBool(), []);
    final messages = ref.watch(chatMessagesProvider);

    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        backgroundColor: context.theme.appColors.secondaryBackground,
        body: SafeArea(
          minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
          ),
          bottom: false,
          child: Column(
            children: [
              MessagingHeader(
                imageUrl: 'https://i.pravatar.cc/150?u=@anna',
                isVerified: true,
                name: 'Selena Maringue',
                subtitle: Text(
                  '@selenamaringue',
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.quaternaryText,
                  ),
                ),
              ),
              if (isEmpty)
                MessagingEmptyView(
                  title: context.i18n.messaging_empty_description,
                  asset: Assets.svg.walletChatEmptystate,
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
                )
              else
                Expanded(
                  child: ChatMessagesList(messages),
                ),
              const MessagingBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
