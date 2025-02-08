// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat-v2/providers/messaging_bottom_bar_state_provider.c.dart';

class CancelRecordButton extends ConsumerWidget {
  const CancelRecordButton({
    required this.recorderController,
    super.key,
  });

  final ObjectRef<RecorderController> recorderController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0.s),
      child: GestureDetector(
        onTap: () {
          recorderController.value.stop();
          ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
        },
        child: Text(
          'Cancel',
          style: context.theme.appTextThemes.body2.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ),
    );
  }
}
