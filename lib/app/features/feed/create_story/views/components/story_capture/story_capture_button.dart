// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_capture/inner_capture_circle.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_capture/story_circular_progress_indicator.dart';

class StoryCaptureButton extends StatelessWidget {
  const StoryCaptureButton({
    required this.isRecording,
    required this.recordingProgress,
    required this.onRecordingStart,
    required this.onRecordingStop,
    super.key,
  });

  final bool isRecording;
  final double recordingProgress;
  final Future<void> Function()? onRecordingStart;
  final Future<void> Function()? onRecordingStop;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onRecordingStart != null ? () async => onRecordingStart!() : null,
      onLongPressUp: onRecordingStop != null ? () async => onRecordingStop!() : null,
      child: AnimatedContainer(
        duration: 150.milliseconds,
        width: isRecording ? 100.0.s : 65.0.s,
        height: isRecording ? 100.0.s : 65.0.s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onRecordingStart == null
              ? Colors.transparent
              : (isRecording ? Colors.white.withOpacity(0.5) : Colors.transparent),
          border: Border.all(
            color: context.theme.appColors.onPrimaryAccent,
            width: isRecording ? 0.0.s : 4.0.s,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isRecording)
              StoryCircularProgressIndicator(
                progress: recordingProgress,
              ),
            const InnerCaptureCircle(),
          ],
        ),
      ),
    );
  }
}
