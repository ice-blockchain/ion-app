// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/components/components.dart';

class MessagingBottomBar extends HookConsumerWidget {
  const MessagingBottomBar({required this.onSubmitted, super.key});

  final Future<void> Function(String? content) onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);

    final controller = useTextEditingController();

    return Stack(
      alignment: Alignment.center,
      children: [
        AbsorbPointer(
          absorbing: bottomBarState.isVoice,
          child: BottomBarInitialView(controller: controller),
        ),
        if (bottomBarState.isVoice || bottomBarState.isVoiceLocked || bottomBarState.isVoicePaused)
          const BottomBarRecordingView(),
        ActionButton(
          controller: controller,
          onSubmitted: () async {
            await onSubmitted(controller.text);
          },
        ),
      ],
    );
  }
}
