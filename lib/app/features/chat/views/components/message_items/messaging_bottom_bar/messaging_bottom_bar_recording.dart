// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/components/components.dart';
import 'package:ion/app/services/audio_wave_playback_service/audio_wave_playback_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:mime/mime.dart';

class BottomBarRecordingView extends HookConsumerWidget {
  const BottomBarRecordingView({
    required this.onRecordingFinished,
    required this.recorderController,
    super.key,
  });

  final void Function(MediaFile mediaFile) onRecordingFinished;
  final RecorderController recorderController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = useRef(
      PlayerController(),
    );
    final playerState = useState<PlayerState?>(null);
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);
    final duration = useState('00:00');

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
        final durationSubscription = recorderController.onCurrentDuration.listen((event) {
          duration.value = formatDuration(event);
        });

        final playerStateSubscription = playerController.value.onPlayerStateChanged.listen((event) {
          if (event != PlayerState.stopped) {
            playerState.value = event;
          }
        });

        recorderController.record(
          bitRate: 44100,
        );

        return () {
          durationSubscription.cancel();
          playerStateSubscription.cancel();
          playerController.value.dispose();
          recorderController.reset();
        };
      },
      [],
    );

    useEffect(
      () {
        if (bottomBarState.isVoicePaused) {
          recorderController.stop().then((path) {
            if (path == null) {
              return;
            }
            ref.read(audioWavePlaybackServiceProvider).preparePlayer(
                  path,
                  playerController.value,
                  playerWaveStyle,
                );
            final mimetype = lookupMimeType(path);
            onRecordingFinished(MediaFile(path: path, mimeType: mimetype));
          });
        }
        return null;
      },
      [bottomBarState],
    );

    return Container(
      color: context.theme.appColors.onPrimaryAccent,
      constraints: BoxConstraints(
        minHeight: 48.0.s,
      ),
      width: double.infinity,
      child: Row(
        children: [
          if (bottomBarState.isVoicePaused) ...[
            const DeleteAudioButton(),
            SizedBox(width: 6.0.s),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.0.s, horizontal: 8.0.s),
                decoration: BoxDecoration(
                  color: context.theme.appColors.primaryBackground,
                  borderRadius: BorderRadius.circular(16.0.s),
                ),
                child: Row(
                  children: [
                    if (playerState.value == null) ...[
                      const IONLoadingIndicator(
                        type: IndicatorType.dark,
                      ),
                    ] else if (playerState.value!.isPlaying) ...[
                      PlayAudioButton(playerController: playerController),
                    ] else
                      PauseAudioButton(playerController: playerController),
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
                    DurationText(duration: duration.value),
                  ],
                ),
              ),
            ),
          ] else ...[
            CancelRecordButton(recorderController: recorderController),
            const Spacer(),
            const RecordingRedIndicator(),
            SizedBox(width: 4.0.s),
            DurationText(duration: duration.value),
          ],
          SizedBox(width: 62.0.s),
        ],
      ),
    );
  }
}
