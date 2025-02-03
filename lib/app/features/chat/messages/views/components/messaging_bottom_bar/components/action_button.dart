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
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/conversation_data.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversation_metadata_provider.c.dart';
import 'package:ion/app/features/core/views/pages/error_modal.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class ActionButton extends HookConsumerWidget {
  const ActionButton({
    required this.conversation,
    required this.controller,
    super.key,
  });

  final ConversationEntity conversation;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);
    final paddingBottom = useState<double>(0);
    final sendButtonDisabled = useState<bool>(false);

    final conversationMetadata =
        ref.watch(conversationMetadataProvider(conversation, loadPubkeys: true)).value;

    final pubkeysLoaded =
        conversationMetadata?.participants.every((p) => p.pubkey.isNotEmpty) ?? false;

    ref.displayErrors(conversationMetadataProvider(conversation));

    Future<void> sendMessage() async {
      try {
        ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
        final conversationMessageManagementService =
            await ref.read(conversationMessageManagementServiceProvider.future);

        if (conversationMetadata?.participants != null) {
          await conversationMessageManagementService.sendMessage(
            content: controller.text,
            conversationId: conversation.id,
            participants: conversationMetadata!.participants,
            subject: conversation.type == ChatType.group ? conversation.name : null,
          );
        }
      } catch (e) {
        if (context.mounted) {
          await showSimpleBottomSheet<void>(
            context: context,
            child: ErrorModal(error: e),
          );
        }
      }
    }

    final onSend = useCallback(
      () async {
        sendButtonDisabled.value = true;

        if (controller.text.isNotEmpty) {
          await sendMessage();
        }

        sendButtonDisabled.value = false;
      },
      [pubkeysLoaded],
    );

    Widget subButton() {
      switch (bottomBarState) {
        case MessagingBottomBarState.hasText:
        case MessagingBottomBarState.voicePaused:
          return SendButton(
            onSend: onSend,
            disabled: sendButtonDisabled.value || !pubkeysLoaded,
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
