// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class StoryProgressFill extends StatelessWidget {
  const StoryProgressFill({
    required this.isActive,
    required this.storyProgress,
    super.key,
  });

  final bool isActive;
  final double storyProgress;

  @override
  Widget build(BuildContext context) {
    final fillColor = context.theme.appColors.onPrimaryAccent;

    return RepaintBoundary(
      child: CustomPaint(
        painter: isActive
            ? _StoryProgressPainter(
                progress: storyProgress.clamp(0.0, 1.0),
                fillColor: fillColor,
              )
            : null,
      ),
    );
  }
}

class _StoryProgressPainter extends CustomPainter {
  _StoryProgressPainter({
    required this.progress,
    required this.fillColor,
  });
  final double progress;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = fillColor;
    final fillWidth = progress * size.width;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, fillWidth, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _StoryProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.fillColor != fillColor;
  }
}
