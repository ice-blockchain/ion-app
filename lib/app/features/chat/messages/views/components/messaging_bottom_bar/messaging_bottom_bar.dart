// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_bottom_bar/messaging_bottom_bar_initial.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_bottom_bar/messaging_bottom_bar_recording.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.dart';

class MessagingBottomBar extends HookConsumerWidget {
  const MessagingBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messaingBottomBarActiveStateProvider);

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: bottomBarState.isVoice,
          child: const BottomBarInitialView(),
        ),
        if (bottomBarState.isVoice) const BottomBarRecordingView(),
      ],
    );
  }
}
