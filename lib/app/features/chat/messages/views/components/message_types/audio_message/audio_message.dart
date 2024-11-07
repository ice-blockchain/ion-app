// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/hooks/use_audio_playback_controller.dart';
import 'package:ion/app/features/chat/messages/views/components/audio_loading_indicator/audio_loading_indicator.dart';
import 'package:ion/app/features/chat/messages/views/components/mesage_timestamp/mesage_timestamp.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/services/audio_wave_playback_service/audio_wave_playback_service.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'components/audio_wave_form_display.dart';
part 'components/play_pause_button.dart';

class AudioMessage extends HookConsumerWidget {
  const AudioMessage(
    this.id, {
    required this.audioUrl,
    required this.isMe,
    super.key,
  });

  final bool isMe;
  final String audioUrl;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final audioPlaybackState = useState<PlayerState?>(null);
    final audioPlaybackController = useAudioWavePlaybackController();

    final playerWaveStyle = useMemoized(
      () => PlayerWaveStyle(
        liveWaveColor:
            isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryText,
        fixedWaveColor: context.theme.appColors.sheetLine,
        seekLineColor: Colors.transparent,
        waveThickness: 1.0.s,
        spacing: 2.0.s,
      ),
      [isMe],
    );

    useEffect(
      () {
        ref.read(audioWavePlaybackServiceProvider).initializePlayer(
              id,
              audioUrl,
              audioPlaybackController,
              playerWaveStyle,
            );

        // Listen to player state changes
        audioPlaybackController.onPlayerStateChanged.listen((event) {
          if (event != PlayerState.stopped) {
            audioPlaybackState.value = event;
          }
        });

        return null;
      },
      [],
    );

    return MessageItemWrapper(
      isMe: isMe,
      contentPadding: EdgeInsets.all(12.0.s),
      child: VisibilityDetector(
        key: ValueKey(audioUrl),
        onVisibilityChanged: (info) {
          if (info.visibleFraction == 0) {
            audioPlaybackController.pausePlayer();
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PlayPauseButton(
              audioPlaybackController: audioPlaybackController,
              audioPlaybackState: audioPlaybackState,
            ),
            SizedBox(width: 8.0.s),
            _AudioWaveformDisplay(
              audioPlaybackController: audioPlaybackController,
              audioPlaybackState: audioPlaybackState,
              playerWaveStyle: playerWaveStyle,
              isMe: isMe,
            ),
            MessageTimeStamp(isMe: isMe),
          ],
        ),
      ),
    );
  }
}
