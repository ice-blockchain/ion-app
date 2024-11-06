// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_bottom_bar/messaging_bottom_bar_initial.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_bottom_bar/messaging_bottom_bar_recording.dart';
import 'package:ion/app/features/chat/models/messaging_bottom_bar_state.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.dart';
import 'package:ion/generated/assets.gen.dart';

part './components/action_button.dart';
part './components/audio_record_button.dart';
part './components/recording_overlay.dart';
part './components/send_button.dart';

class MessagingBottomBar extends ConsumerWidget {
  const MessagingBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        AbsorbPointer(
          absorbing: bottomBarState.isVoice,
          child: const BottomBarInitialView(),
        ),
        if (bottomBarState.isVoice || bottomBarState.isVoiceLocked || bottomBarState.isVoicePaused)
          const BottomBarRecordingView(),
        const _ActionButton(),
      ],
    );
  }
}
