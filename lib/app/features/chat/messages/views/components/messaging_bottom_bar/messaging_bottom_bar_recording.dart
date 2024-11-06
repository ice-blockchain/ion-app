// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/audio_loading_indicator.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class BottomBarRecordingView extends HookConsumerWidget {
  const BottomBarRecordingView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderController = useRef(
      RecorderController(),
    );
    final playerController = useRef(
      PlayerController(),
    );
    final playerState = useState<PlayerState?>(null);

    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);

    final duration = useState('00:00');

    final playerWaveStyle = PlayerWaveStyle(
      liveWaveColor: context.theme.appColors.primaryText,
      fixedWaveColor: context.theme.appColors.sheetLine,
      seekLineColor: Colors.transparent,
      waveThickness: 1.0.s,
      spacing: 1.5.s,
    );

    useEffect(
      () {
        recorderController.value.record();
        recorderController.value.onCurrentDuration.listen((event) {
          duration.value = formatDuration(event);
        });

        playerController.value.onPlayerStateChanged.listen((event) {
          if (event != PlayerState.stopped) {
            playerState.value = event;
          }
        });

        return () {
          playerController.value.dispose();
          recorderController.value.dispose();
        };
      },
      [],
    );

    useEffect(
      () {
        if (bottomBarState.isVoicePaused) {
          recorderController.value.stop().then((path) {
            if (path == null) {
              return;
            }
            playerController.value.preparePlayer(
              path: path,
              noOfSamples: playerWaveStyle.getSamplesForWidth(169.0.s),
            );
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
            GestureDetector(
              onTap: () {
                ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.0.s, 4.0.s, 4.0.s, 4.0.s),
                child: Assets.svg.iconBlockDelete.icon(
                  color: context.theme.appColors.primaryText,
                  size: 24.0.s,
                ),
              ),
            ),
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
                      const AudioLoadingIndicator(),
                    ] else if (playerState.value!.isPlaying) ...[
                      GestureDetector(
                        onTap: () {
                          playerController.value.pausePlayer();
                        },
                        child: Assets.svg.iconVideoPause.icon(
                          color: context.theme.appColors.primaryAccent,
                          size: 24.0.s,
                        ),
                      ),
                    ] else
                      GestureDetector(
                        onTap: () {
                          playerController.value.startPlayer(
                            finishMode: FinishMode.pause,
                          );
                        },
                        child: Assets.svg.iconVideoPlay.icon(
                          color: context.theme.appColors.primaryAccent,
                          size: 24.0.s,
                        ),
                      ),
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
                    Text(
                      duration.value,
                      style: context.theme.appTextThemes.body2.copyWith(
                        color: context.theme.appColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Padding(
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
            ),
            const Spacer(),
            Container(
              width: 4.0.s,
              height: 4.0.s,
              decoration: BoxDecoration(
                color: context.theme.appColors.attentionRed,
                borderRadius: BorderRadius.circular(12.0.s),
              ),
            ),
            SizedBox(width: 4.0.s),
            Text(
              duration.value,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
          ],
          SizedBox(width: 62.0.s),
        ],
      ),
    );
  }
}
