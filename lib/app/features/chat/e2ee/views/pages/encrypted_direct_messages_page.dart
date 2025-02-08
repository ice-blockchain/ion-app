// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/providers/conversation_messages_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/messaging_bottom_bar.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_empty_view/messaging_empty_view.dart';
import 'package:ion/app/features/chat/views/components/messages_list.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class EncryptedDirectMessagesPage extends HookConsumerWidget {
  const EncryptedDirectMessagesPage({
    required this.uuid,
    required this.receiverPubKey,
    super.key,
  });

  final String uuid;
  final String receiverPubKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.displayErrors(conversationMessageManagementServiceProvider);

    final receiver = ref.watch(userMetadataProvider(receiverPubKey)).valueOrNull;

    final messages = ref.watch(conversationMessagesProvider(uuid));

    if (receiver == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: KeyboardDismissOnTap(
        child: SafeArea(
          minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
          ),
          bottom: false,
          child: Column(
            children: [
              MessagingHeader(
                imageUrl: receiver.data.picture,
                name: receiver.data.displayName,
                subtitle: Text(
                  prefixUsername(username: receiver.data.name, context: context),
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.quaternaryText,
                  ),
                ),
              ),
              Expanded(
                child: messages.when(
                  data: (messages) {
                    if (messages.isEmpty) {
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

                    return ChatMessagesList(messages);
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
              MessagingBottomBar(
                onSubmitted: (content) async {
                  final currentPubkey = await ref.read(currentPubkeySelectorProvider.future);
                  if (currentPubkey == null) {
                    throw UserMasterPubkeyNotFoundException();
                  }

                  final conversationMessageManagementService =
                      await ref.read(conversationMessageManagementServiceProvider.future);

                  await conversationMessageManagementService.sendMessage(
                    conversationId: uuid,
                    content: content ?? '',
                    participantsMasterkeys: [currentPubkey, receiverPubKey],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
