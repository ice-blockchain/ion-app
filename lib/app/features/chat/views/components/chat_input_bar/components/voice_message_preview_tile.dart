// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/components/chat_input_bar/components/duration_text.dart';
import 'package:ion/app/features/chat/views/components/chat_input_bar/components/pause_audio_button.dart';
import 'package:ion/app/features/chat/views/components/chat_input_bar/components/play_audio_button.dart';
import 'package:ion/app/services/audio_wave_playback_service/audio_wave_playback_service.r.dart';

class VoiceMessagePreviewTile extends HookConsumerWidget {
  const VoiceMessagePreviewTile({
    required this.duration,
    required this.path,
    super.key,
  });
  final String duration;
  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = useRef(PlayerController());
    final playerState = useState<PlayerState?>(null);
    final playerWaveStyle = useMemoized(
      () => PlayerWaveStyle(
        liveWaveColor: context.theme.appColors.primaryText,
        fixedWaveColor: context.theme.appColors.sheetLine,
        seekLineColor: Colors.transparent,
        waveThickness: 1.0.s,
        spacing: 1.5.s,
      ),
    );

    useEffect(
      () {
        final playerStateSubscription =
            playerController.value.onPlayerStateChanged.listen((currentPlayerState) {
          if (currentPlayerState != PlayerState.stopped) {
            playerState.value = currentPlayerState;
          }
        });

        ref.read(audioWavePlaybackServiceProvider).preparePlayer(
              path,
              playerController.value,
              playerWaveStyle,
            );

        return () {
          playerStateSubscription.cancel();
          playerController.value.dispose();
        };
      },
      [],
    );
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0.s, horizontal: 8.0.s),
        decoration: BoxDecoration(
          color: context.theme.appColors.primaryBackground,
          borderRadius: BorderRadius.circular(16.0.s),
        ),
        child: Row(
          children: [
            if (playerState.value == null)
              const IONLoadingIndicator(
                type: IndicatorType.dark,
              )
            else if (playerState.value!.isPlaying)
              PauseAudioButton(playerController: playerController.value)
            else
              PlayAudioButton(playerController: playerController.value),
            SizedBox(width: 6.0.s),
            AudioFileWaveforms(
              playerController: playerController.value,
              size: Size(169.0.s, 16.0.s),
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              continuousWaveform: false,
              waveformType: WaveformType.fitWidth,
              playerWaveStyle: playerWaveStyle,
            ),
            const Spacer(),
            DurationText(duration: duration),
          ],
        ),
      ),
    );
  }
}
