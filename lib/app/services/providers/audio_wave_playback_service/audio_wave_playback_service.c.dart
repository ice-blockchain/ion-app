// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_wave_playback_service.c.g.dart';

class AudioWavePlaybackService {
  const AudioWavePlaybackService();

  Future<void> initializePlayer(
    String id,
    String audioUrl,
    PlayerController audioPlaybackController,
    PlayerWaveStyle playerWaveStyle,
  ) async {
    try {
      await preparePlayer(audioUrl, audioPlaybackController, playerWaveStyle);
    } catch (e, s) {
      Logger.log('Error initializing player', error: e, stackTrace: s);
    }
  }

  Future<void> preparePlayer(
    String path,
    PlayerController audioPlaybackController,
    PlayerWaveStyle playerWaveStyle,
  ) async {
    try {
      await audioPlaybackController.preparePlayer(
        path: path,
        noOfSamples: playerWaveStyle.getSamplesForWidth(158.0.s),
      );
    } catch (e, s) {
      Logger.log('Error preparing player', error: e, stackTrace: s);
    }
  }
}

@riverpod
AudioWavePlaybackService audioWavePlaybackService(Ref ref) => const AudioWavePlaybackService();
