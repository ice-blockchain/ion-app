// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class PauseAudioButton extends StatelessWidget {
  const PauseAudioButton({
    required this.playerController,
    super.key,
  });

  final ObjectRef<PlayerController> playerController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        playerController.value.setFinishMode(finishMode: FinishMode.pause);
        playerController.value.startPlayer();
      },
      child: Assets.svg.iconVideoPlay.icon(
        color: context.theme.appColors.primaryAccent,
        size: 24.0.s,
      ),
    );
  }
}
