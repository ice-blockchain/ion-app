// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_bottom_bar/components/components.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/model/messaging_bottom_bar_state.dart';
import 'package:ion/app/features/chat/providers/conversation_message_management_provider.c.dart';
import 'package:ion/app/features/chat/providers/e2ee_conversation_management_provider.c.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/ee2e_conversation_data.c.dart';
import 'package:ion/app/features/chat/database/conversation_db_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class ActionButton extends HookConsumerWidget {
  const ActionButton({
    required this.e2eeConversation,
    required this.controller,
    super.key,
  });

  final TextEditingController controller;
  final E2eeConversationEntity? e2eeConversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);
    final paddingBottom = useState<double>(0);

    final sentMessage = useCallback(() async {
      if (e2eeConversation == null) return;

      final conversationId = await ref
          .read(conversationsDBServiceProvider)
          .lookupConversationByPubkeys(e2eeConversation!.participants.join(','));
      if (e2eeConversation!.id == null && conversationId == null) {
        final ee2eGroupConversationService = ref.read(e2eeConversationManagementProvider.notifier);

        if (e2eeConversation!.type == ChatType.chat) {
          await ee2eGroupConversationService
              .createOneOnOneConversation(e2eeConversation!.participants);
        } else if (e2eeConversation!.type == ChatType.group && e2eeConversation!.imageUrl != null) {
          await ee2eGroupConversationService.createGroup(
            subject: e2eeConversation!.name,
            groupImage: MediaFile(
              mimeType: 'image/webp',
              path: e2eeConversation!.imageUrl!,
              width: e2eeConversation!.imageWidth,
              height: e2eeConversation!.imageHeight,
            ),
            participantsPubkeys: e2eeConversation!.participants,
          );
        }
      }

      if (controller.text.isNotEmpty) {
        ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
        await (await ref.read(conversationMessageManagementServiceProvider.future)).sentMessage(
          content: controller.text,
          participantsPubkeys: e2eeConversation!.participants,
          subject: e2eeConversation!.type == ChatType.group ? e2eeConversation!.name : null,
        );
      }
    });

    Widget subButton() {
      switch (bottomBarState) {
        case MessagingBottomBarState.hasText:
        case MessagingBottomBarState.voicePaused:
          return SendButton(onSend: sentMessage);
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
