// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/messaging_bottom_bar_state.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.r.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/components/components.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.r.dart';

class ActionButton extends HookConsumerWidget {
  const ActionButton({
    required this.controller,
    required this.onSubmitted,
    required this.recorderController,
    required this.paddingBottom,
    super.key,
  });

  final TextEditingController controller;
  final Future<void> Function()? onSubmitted;
  final RecorderController recorderController;
  final double paddingBottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);
    final paddingBottom = useState<double>(0);
    final onSend = useCallback(() async {
      ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
      await onSubmitted?.call();
    });

    final startRecording = useCallback(
      () async {
        await recorderController.record(bitRate: 44100);
      },
      [recorderController],
    );

    final isRecordingCancelled = useRef<bool>(false);

    Widget subButton() {
      switch (bottomBarState) {
        case MessagingBottomBarState.hasText:
          return SendButton(
            onSend: onSend,
            disabled: onSubmitted == null,
          );
        case MessagingBottomBarState.voicePaused:
        case MessagingBottomBarState.voice:
        case MessagingBottomBarState.voiceLocked:
          return AudioRecordingButton(
            paddingBottom: paddingBottom.value,
            onSubmitted: onSend,
            onResumeRecording: () async {
              ref.read(messagingBottomBarActiveStateProvider.notifier).setVoiceLocked();
              await startRecording();
            },
          );
        case MessagingBottomBarState.text:
        case MessagingBottomBarState.more:
          return const AudioRecordButton();
      }
    }

    return PositionedDirectional(
      bottom: 8.0.s + (bottomBarState.isMore ? moreContentHeight : 0),
      end: 12.0.s,
      child: GestureDetector(
        onLongPressStart: (details) async {
          if (!bottomBarState.isVoice) {
            await ref.read(permissionsProvider.notifier).checkPermission(Permission.microphone);
            final status = ref.read(
              permissionsProvider.select((value) => value.permissions[Permission.microphone]),
            );
            if (status == PermissionStatus.granted) {
              isRecordingCancelled.value = false;
              await startRecording();
              if (isRecordingCancelled.value) {
                await recorderController.stop();
                return;
              }
              ref.read(messagingBottomBarActiveStateProvider.notifier).setVoice();
              unawaited(HapticFeedback.lightImpact());
            } else {
              unawaited(
                ref.read(permissionsProvider.notifier).requestPermission(Permission.microphone),
              );
            }
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
          if (recorderController.elapsedDuration > Duration.zero) {
            if (paddingBottom.value > 20) {
              ref.read(messagingBottomBarActiveStateProvider.notifier).setVoiceLocked();
              paddingBottom.value = 0;
            } else {
              ref.read(messagingBottomBarActiveStateProvider.notifier).setVoicePaused();
            }
          } else {
            isRecordingCancelled.value = true;
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
