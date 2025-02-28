// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/messaging_bottom_bar_state.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/components/components.dart';

class ActionButton extends HookConsumerWidget {
  const ActionButton({
    required this.controller,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final Future<void> Function()? onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);
    final paddingBottom = useState<double>(0);

    final onSend = useCallback(() async {
      ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
      await onSubmitted?.call();
    });

    Widget subButton() {
      switch (bottomBarState) {
        case MessagingBottomBarState.hasText:
        case MessagingBottomBarState.voicePaused:
          return SendButton(
            onSend: onSend,
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
          } else {
            ref.read(messagingBottomBarActiveStateProvider.notifier).setVoicePaused();
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
