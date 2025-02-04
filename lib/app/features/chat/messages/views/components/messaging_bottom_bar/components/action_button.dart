// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_bottom_bar/components/components.dart';
import 'package:ion/app/features/chat/model/messaging_bottom_bar_state.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';

class ActionButton extends HookConsumerWidget {
  const ActionButton({
    required this.controller,
    required this.onSubmitted,
    super.key,
  });

  final ConversationEntity conversation;
  final TextEditingController controller;
  final Future<void> Function()? onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);
    final paddingBottom = useState<double>(0);
    final sendButtonDisabled = useState<bool>(false);
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

    final onSend = useCallback(() async {
      sendButtonDisabled.value = true;
      await onSubmitted?.call();
      sendButtonDisabled.value = false;

      // await ref
      //     .read(
      //       createPostNotifierProvider(
      //         CreatePostOption.plain,
      //       ).notifier,
      //     )
      //     .create(
      //       content: controller.text,
      //       whoCanReply: WhoCanReplySettingsOption.everyone,
      //       communityUuid: e2eeConversation?.communityUuid,
      //     );
      // if (e2eeConversation == null) return;

      // sendButtonDisabled.value = true;

      // final conversationId = await lookupConversation();
      // if (e2eeConversation!.id == null && conversationId == null) {
      //   await createConversation();
      // }

      // if (controller.text.isNotEmpty) {
      //   await sendMessage();
      // }

      // sendButtonDisabled.value = false;
    });

    Widget subButton() {
      switch (bottomBarState) {
        case MessagingBottomBarState.hasText:
        case MessagingBottomBarState.voicePaused:
          return SendButton(
            onSend: onSend,
            disabled: sendButtonDisabled.value,
          );
        case MessagingBottomBarState.voice:
        case MessagingBottomBarState.voiceLocked:
          return AudioRecordingButton(paddingBottom: paddingBottom.value);
        case MessagingBottomBarState.text:
        case MessagingBottomBarState.more:
          return const AudioRecordButton();
      }
    }

    return Positioned(
      bottom: 8.0.s + (bottomBarState.isMore ? moreContentHeight : 0),
      right: 14.0.s,
      child: GestureDetector(
        onLongPressStart: (details) {
          if (!bottomBarState.isVoice) {
            ref.read(messagingBottomBarActiveStateProvider.notifier).setVoice();
            HapticFeedback.lightImpact();
          }
        },
        onTap: () {
          if (bottomBarState.isVoice) {
            ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
          }
        },
        onLongPressMoveUpdate: (details) {
          if (details.localOffsetFromOrigin.dy < 0) {
            paddingBottom.value = details.localOffsetFromOrigin.dy * -1;
          } else {
            paddingBottom.value = 0;
          }
        },
        onLongPressEnd: (details) {
          if (paddingBottom.value > 20) {
            ref.read(messagingBottomBarActiveStateProvider.notifier).setVoiceLocked();
            paddingBottom.value = 0;
          }
        },
        child: AbsorbPointer(
          absorbing: bottomBarState.isVoiceLocked,
          child: subButton(),
        ),
      ),
    );
  }
}
