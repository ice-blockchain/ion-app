// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessagesPage extends HookConsumerWidget {
  const MessagesPage({
    required this.uuid,
    super.key,
  });

  final String uuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Text(uuid),
    );
  }
}

    // ref
    //   ..displayErrors(e2eeConversationManagementProvider)
    //   ..displayErrors(chatMessagesProvider(_conversation));

    // return Scaffold(
    //   backgroundColor: context.theme.appColors.secondaryBackground,
    //   body: SafeArea(
    //     minimum: EdgeInsets.only(
    //       bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
    //     ),
    //     bottom: false,
    //     child: Column(
    //       children: [
    //         MessagingHeader(
    //           imageUrl: _conversation.imageUrl,
    //           imageWidget: _conversation.imageUrl != null &&
    //                   _conversation.imageUrl.isNotEmpty &&
    //                   _conversation.type == ChatType.group
    //               ? Image.asset(_conversation.imageUrl!)
    //               : null,
    //           name: _conversation.name,
    //           subtitle: _conversation.type == ChatType.chat
    //               ? Text(
    //                   _conversation.nickname ?? '',
    //                   style: context.theme.appTextThemes.caption.copyWith(
    //                     color: context.theme.appColors.quaternaryText,
    //                   ),
    //                 )
    //               : Row(
    //                   children: [
    //                     Assets.svg.iconChannelMembers.icon(size: 10.0.s),
    //                     SizedBox(width: 4.0.s),
    //                     Text(
    //                       _conversation.participants.length.toString(),
    //                       style: context.theme.appTextThemes.caption.copyWith(
    //                         color: context.theme.appColors.quaternaryText,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //         ),
    //         if (messages.isEmpty)
    //           MessagingEmptyView(
    //             title: context.i18n.messaging_empty_description,
    //             asset: Assets.svg.walletChatEmptystate,
    //             trailing: GestureDetector(
    //               onTap: () {
    //                 ChatLearnMoreModalRoute().push<void>(context);
    //               },
    //               child: Text(
    //                 context.i18n.button_learn_more,
    //                 style: context.theme.appTextThemes.caption.copyWith(
    //                   color: context.theme.appColors.primaryAccent,
    //                 ),
    //               ),
    //             ),
    //           )
    //         else
    //           Expanded(
    //             child: ChatMessagesList(messages),
    //           ),
    //         MessagingBottomBar(
    //           onSubmitted: (content) async {
    //             final service = await ref.read(conversationMessageManagementServiceProvider.future);
    //             await service.sentMessage(
    //               content: content ?? '',
    //               participantsPubkeys: _conversation.participants,
    //             );

    //             // Future<String?> lookupConversation() async {
    //             //   return ref
    //             //       .read(conversationsDBServiceProvider)
    //             //       .lookupConversationByPubkeys(e2eeConversation!.participants.join(','));
    //             // }

    //             // Future<void> createConversation() async {
    //             //   final ee2eGroupConversationService = ref.watch(e2eeConversationManagementProvider.notifier);

    //             //   if (e2eeConversation!.type == ChatType.chat) {
    //             //     await ee2eGroupConversationService
    //             //         .createOneOnOneConversation(e2eeConversation!.participants);
    //             //   } else if (e2eeConversation!.type == ChatType.group && e2eeConversation!.imageUrl != null) {
    //             //     await ee2eGroupConversationService.createGroup(
    //             //       subject: e2eeConversation!.name,
    //             //       groupImage: MediaFile(
    //             //         mimeType: 'image/webp',
    //             //         path: e2eeConversation!.imageUrl!,
    //             //         width: e2eeConversation!.imageWidth,
    //             //         height: e2eeConversation!.imageHeight,
    //             //       ),
    //             //       participantsPubkeys: e2eeConversation!.participants,
    //             //     );
    //             //   }
    //             // }

    //             // Future<void> sendMessage() async {
    //             //   ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
    //             //   await (await ref.read(conversationMessageManagementServiceProvider.future)).sentMessage(
    //             //     content: controller.text,
    //             //     participantsPubkeys: e2eeConversation!.participants,
    //             //     subject: e2eeConversation!.type == ChatType.group ? e2eeConversation!.name : null,
    //             //   );
    //             // }
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
//     )
//   }
// }
