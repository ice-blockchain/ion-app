// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class PlayAudioButton extends StatelessWidget {
  const PlayAudioButton({
    required this.playerController,
    super.key,
  });

  final PlayerController playerController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        playerController
          ..setFinishMode(finishMode: FinishMode.pause)
          ..startPlayer();
      },
      child: IconAssetColored(
        Assets.svgIconVideoPlay,
        color: context.theme.appColors.primaryAccent,
        size: 24,
      ),
    );
  }
}
