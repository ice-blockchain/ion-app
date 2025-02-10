// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/views/components/one_to_one_messages_list.dart';
import 'package:ion/app/features/chat/providers/conversation_messages_provider.c.dart';
import 'package:ion/app/features/chat/providers/exist_chat_conversation_id_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/messaging_bottom_bar.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_empty_view/messaging_empty_view.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class OneToOneMessagesPage extends HookConsumerWidget {
  const OneToOneMessagesPage({
    required this.receiverPubKey,
    super.key,
  });

  final String receiverPubKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.displayErrors(sendE2eeMessageServiceProvider);

    final onSubmitted = useCallback(
      (String? content) async {
        final existConversationId =
            await ref.watch(existChatConversationIdProvider(receiverPubKey).future);

        final currentPubkey = await ref.read(currentPubkeySelectorProvider.future);
        if (currentPubkey == null) {
          throw UserMasterPubkeyNotFoundException();
        }
        final conversationMessageManagementService =
            await ref.read(sendE2eeMessageServiceProvider.future);

        await conversationMessageManagementService.sendMessage(
          conversationId: existConversationId ?? generateUuid(),
          content: content ?? '',
          participantsMasterkeys: [receiverPubKey, currentPubkey],
        );
      },
      [receiverPubKey],
    );

    return Scaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: SafeArea(
        minimum: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
        ),
        bottom: false,
        child: Column(
          children: [
            _Header(receiverMasterPubKey: receiverPubKey),
            _MessagesList(receiverPubKey: receiverPubKey),
            MessagingBottomBar(
              onSubmitted: onSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends HookConsumerWidget {
  const _Header({required this.receiverMasterPubKey});

  final String receiverMasterPubKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiver = ref.watch(userMetadataProvider(receiverMasterPubKey)).valueOrNull;

    if (receiver == null) {
      return const SizedBox.shrink();
    }

    return MessagingHeader(
      imageUrl: receiver.data.picture,
      name: receiver.data.displayName,
      subtitle: Text(
        prefixUsername(username: receiver.data.name, context: context),
        style: context.theme.appTextThemes.caption.copyWith(
          color: context.theme.appColors.quaternaryText,
        ),
      ),
    );
  }
}

class _MessagesList extends HookConsumerWidget {
  const _MessagesList({required this.receiverPubKey});

  final String receiverPubKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationId = ref.watch(existChatConversationIdProvider(receiverPubKey)).valueOrNull;
    final messages = ref.watch(conversationMessagesProvider(conversationId ?? ''));
    return Expanded(
      child: messages.when(
        data: (messages) {
          if (messages.isEmpty) {
            return const _EmptyView();
          }
          return OneToOneMessageList(messages);
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

class _EmptyView extends HookConsumerWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MessagingEmptyView(
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
    );
  }
}
