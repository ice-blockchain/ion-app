import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/create_story/views/components/inner_capture_circle.dart';
import 'package:ice/app/features/feed/create_story/views/components/recording_progress_indicator.dart';

class CaptureButton extends StatelessWidget {
  const CaptureButton({
    required this.isRecording,
    required this.recordingProgress,
    required this.onRecordingStart,
    required this.onRecordingStop,
    super.key,
  });

  final bool isRecording;
  final double recordingProgress;
  final VoidCallback onRecordingStart;
  final VoidCallback onRecordingStop;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onRecordingStart,
      onLongPressUp: onRecordingStop,
      child: AnimatedContainer(
        duration: 150.milliseconds,
        width: isRecording ? 100.0.s : 65.0.s,
        height: isRecording ? 100.0.s : 65.0.s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isRecording ? Colors.white.withOpacity(0.5) : Colors.transparent,
          border: Border.all(
            color: Colors.white,
            width: isRecording ? 0.0.s : 4.0.s,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isRecording)
              RecordingProgressIndicator(
                progress: recordingProgress,
              ),
            const InnerCaptureCircle(),
          ],
        ),
      ),
    );
  }
}
