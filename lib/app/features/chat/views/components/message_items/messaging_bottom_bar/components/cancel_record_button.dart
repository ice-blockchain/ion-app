// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';

class CancelRecordButton extends ConsumerWidget {
  const CancelRecordButton({
    required this.recorderController,
    super.key,
  });

  final RecorderController recorderController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 16.0.s),
      child: GestureDetector(
        onTap: () {
          recorderController.stop();
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
