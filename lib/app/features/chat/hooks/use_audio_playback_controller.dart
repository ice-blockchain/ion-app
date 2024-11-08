// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

///
/// Hook to use the [PlayerController] of the waveforms audio player.
///
PlayerController useAudioWavePlaybackController() {
  final controller = useMemoized(PlayerController.new);
  useEffect(
    () {
      return controller.dispose;
    },
    [controller],
  );

  return controller;
}
