// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/audio_loading_indicator.dart';
import 'package:ion/app/features/chat/messages/views/components/mesage_timestamp.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AudioMessage extends HookWidget {
  const AudioMessage(this.id, {required this.audioUrl, required this.isMe, super.key});
  final bool isMe;
  final String audioUrl;
  final String id;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    final playerState = useState<PlayerState?>(null);

    final playerController = useRef(
      PlayerController(),
    );

    final playerWaveStyle = PlayerWaveStyle(
      liveWaveColor:
          isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryText,
      fixedWaveColor: context.theme.appColors.sheetLine,
      seekLineColor: Colors.transparent,
      waveThickness: 1.0.s,
      spacing: 2.0.s,
    );

    useEffect(
      () {
        getApplicationDocumentsDirectory().then((value) {
          final isFileExist = File('${value.path}/$id').existsSync();
          if (isFileExist) {
            _preparePlayer(playerController.value, '${value.path}/$id', playerWaveStyle);
          } else {
            FileSaver.instance
                .saveFile(
              name: id,
              link: LinkDetails(link: audioUrl),
            )
                .then((value) {
              _preparePlayer(playerController.value, value, playerWaveStyle);
            });
          }
        });

        playerController.value.onPlayerStateChanged.listen((event) {
          if (event != PlayerState.stopped) {
            playerState.value = event;
          }
        });

        return () {
          playerController.value.dispose();
        };
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
            playerController.value.pausePlayer();
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (playerState.value?.isPlaying ?? false) {
                  playerController.value.pausePlayer();
                  return;
                }
                playerController.value.startPlayer(
                  finishMode: FinishMode.pause,
                );
              },
              child: Container(
                padding: EdgeInsets.all(8.0.s),
                decoration: BoxDecoration(
                  color: context.theme.appColors.tertararyBackground,
                  borderRadius: BorderRadius.circular(12.0.s),
                  border: Border.all(
                    color: context.theme.appColors.onTerararyFill,
                    width: 1.0.s,
                  ),
                ),
                child: playerState.value == null
                    ? const AudioLoadingIndicator()
                    : playerState.value!.isPlaying
                        ? GestureDetector(
                            onTap: () {
                              playerController.value.pausePlayer();
                            },
                            child: Assets.svg.iconVideoPause.icon(
                              size: 20.0.s,
                              color: context.theme.appColors.primaryAccent,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              playerController.value.startPlayer(
                                finishMode: FinishMode.pause,
                              );
                            },
                            child: Assets.svg.iconVideoPlay.icon(
                              size: 20.0.s,
                              color: context.theme.appColors.primaryAccent,
                            ),
                          ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0.s),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AudioFileWaveforms(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    size: Size(158.0.s, 16.0.s),
                    continuousWaveform: false,
                    waveformType: WaveformType.fitWidth,
                    playerWaveStyle: playerWaveStyle,
                    playerController: playerController.value,
                  ),
                  SizedBox(height: 4.0.s),
                  if (playerState.value != null)
                    Text(
                      formatDuration(Duration(milliseconds: playerController.value.maxDuration)),
                      style: context.theme.appTextThemes.caption4.copyWith(
                        color: isMe
                            ? context.theme.appColors.strokeElements
                            : context.theme.appColors.quaternaryText,
                      ),
                    ),
                ],
              ),
            ),
            MessageTimeStamp(isMe: isMe),
          ],
        ),
      ),
    );
  }

  void _preparePlayer(
    PlayerController playerController,
    String path,
    PlayerWaveStyle playerWaveStyle,
  ) {
    playerController.preparePlayer(
      path: path,
      noOfSamples: playerWaveStyle.getSamplesForWidth(158.0.s),
    );
  }
}
