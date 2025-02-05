// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/e2ee/providers/e2ee_messages_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_bottom_bar/messaging_bottom_bar.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_empty_view/messaging_empty_view.dart';
import 'package:ion/app/features/chat/views/components/messages_list.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class MessagesPage extends HookConsumerWidget {
  const MessagesPage({
    required this.uuid,
    required this.receiverPubKey,
    super.key,
  });

  final String uuid;
  final String receiverPubKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.displayErrors(sendE2eeMessageNotifierProvider);

    final receiver = ref.watch(userMetadataProvider(receiverPubKey)).valueOrNull;

    final messages = ref.watch(e2eeMessagesNotifierProvider(uuid));

    if (receiver == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: SafeArea(
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
                receiver.data.name.formatUsername(context: context),
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
                await ref.read(sendE2eeMessageNotifierProvider.notifier).sendOneToOneMessage(
                      uuid,
                      content ?? '',
                      receiverPubKey,
                      null,
                    );
                // final service = await ref.read(conversationMessageManagementServiceProvider.future);
                // await service.sentMessage(
                //   content: content ?? '',
                //   participantsPubkeys: _conversation.participants,
                // );

                // Future<String?> lookupConversation() async {
                //   return ref
                //       .read(conversationsDBServiceProvider)
                //       .lookupConversationByPubkeys(e2eeConversation!.participants.join(','));
                // }

                // Future<void> createConversation() async {
                //   final ee2eGroupConversationService = ref.watch(e2eeConversationManagementProvider.notifier);

                //   if (e2eeConversation!.type == ChatType.chat) {
                //     await ee2eGroupConversationService
                //         .createOneOnOneConversation(e2eeConversation!.participants);
                //   } else if (e2eeConversation!.type == ChatType.group && e2eeConversation!.imageUrl != null) {
                //     await ee2eGroupConversationService.createGroup(
                //       subject: e2eeConversation!.name,
                //       groupImage: MediaFile(
                //         mimeType: 'image/webp',
                //         path: e2eeConversation!.imageUrl!,
                //         width: e2eeConversation!.imageWidth,
                //         height: e2eeConversation!.imageHeight,
                //       ),
                //       participantsPubkeys: e2eeConversation!.participants,
                //     );
                //   }
                // }

                // Future<void> sendMessage() async {
                //   ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                //   await (await ref.read(conversationMessageManagementServiceProvider.future)).sentMessage(
                //     content: controller.text,
                //     participantsPubkeys: e2eeConversation!.participants,
                //     subject: e2eeConversation!.type == ChatType.group ? e2eeConversation!.name : null,
                //   );
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
