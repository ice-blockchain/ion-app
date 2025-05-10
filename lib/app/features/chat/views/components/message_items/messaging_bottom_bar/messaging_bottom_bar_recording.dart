// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/components/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/components/voice_message_preview_tile.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:mime/mime.dart';

class BottomBarRecordingView extends HookConsumerWidget {
  const BottomBarRecordingView({
    required this.onRecordingFinished,
    required this.onCancelled,
    required this.recorderController,
    super.key,
  });

  final Future<String> Function(MediaFile mediaFile) onRecordingFinished;
  final VoidCallback onCancelled;
  final RecorderController recorderController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);
    final duration = useState('00:00');
    final previousDuration = useRef<Duration>(Duration.zero);
    final audioPath = useState<String?>(null);

    useEffect(
      () {
        final recorderStateSubscription = recorderController.onRecorderStateChanged.listen((state) {
          if (state == RecorderState.stopped) {
            previousDuration.value += recorderController.recordedDuration;
          } else {
            audioPath.value = null;
          }
        });

        final durationSubscription = recorderController.onCurrentDuration.listen((currentDuration) {
          duration.value = formatDuration(currentDuration + previousDuration.value);
          if (currentDuration.inSeconds ==
              ReplaceablePrivateDirectMessageData.audioMessageDurationLimitInSeconds) {
            ref.read(messagingBottomBarActiveStateProvider.notifier).setVoicePaused();
            return;
          }
        });

        return () {
          durationSubscription.cancel();
          previousDuration.value = Duration.zero;
          recorderStateSubscription.cancel();
          recorderController.reset();
        };
      },
      [],
    );

    useEffect(
      () {
        if (bottomBarState.isVoicePaused) {
          recorderController.stop().then((path) async {
            if (path == null) {
              return;
            }

            final mimetype = lookupMimeType(path);
            final newAudioPath =
                await onRecordingFinished(MediaFile(path: path, mimeType: mimetype));

            audioPath.value = newAudioPath;
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
            DeleteAudioButton(
              onPressed: onCancelled,
            ),
            SizedBox(width: 6.0.s),
            if (audioPath.value != null)
              VoiceMessagePreviewTile(
                duration: duration.value,
                path: audioPath.value!,
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
