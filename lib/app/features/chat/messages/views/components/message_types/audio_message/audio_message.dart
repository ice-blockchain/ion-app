// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/hooks/use_audio_playback_controller.dart';
import 'package:ion/app/features/chat/messages/views/components/audio_loading_indicator/audio_loading_indicator.dart';
import 'package:ion/app/features/chat/messages/views/components/mesage_timestamp/mesage_timestamp.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'components/audio_wave_form_display.dart';
part 'components/play_pause_button.dart';

class AudioMessage extends HookWidget {
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
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    final audioPlaybackState = useState<PlayerState?>(null);
    final audioPlaybackController = useAudioPlaybackController();

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
        _initializePlayer(
          audioPlaybackController,
          id,
          audioUrl,
          playerWaveStyle,
          audioPlaybackState,
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

Future<void> _initializePlayer(
  PlayerController audioPlaybackController,
  String id,
  String audioUrl,
  PlayerWaveStyle playerWaveStyle,
  ValueNotifier<PlayerState?> audioPlaybackState,
) async {
  Future<void> preparePlayer(String path) async {
    try {
      await audioPlaybackController.preparePlayer(
        path: path,
        noOfSamples: playerWaveStyle.getSamplesForWidth(158.0.s),
      );
    } catch (e, s) {
      Logger.log('Error preparing player', error: e, stackTrace: s);
    }
  }

  try {
    final documentsDir = await getApplicationDocumentsDirectory();
    final cachePath = '${documentsDir.path}/$id';
    final file = File(cachePath);

    if (file.existsSync()) {
      await preparePlayer(cachePath);
    } else {
      final savedFilePath = await FileSaver.instance.saveFile(
        name: id,
        link: LinkDetails(link: audioUrl),
      );
      await preparePlayer(savedFilePath);
    }
  } catch (e, s) {
    Logger.log('Error initializing player', error: e, stackTrace: s);
  }
}
