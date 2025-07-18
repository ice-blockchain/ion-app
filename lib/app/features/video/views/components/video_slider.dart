// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class VideoSlider extends StatelessWidget {
  const VideoSlider({
    required this.duration,
    required this.position,
    this.onChangeStart,
    this.onChangeEnd,
    this.onChanged,
    this.backgroundColor,
    super.key,
  });

  final Duration duration;
  final Duration position;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final ValueChanged<double>? onChanged;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final secondaryBackgroundColor = context.theme.appColors.secondaryBackground;
    final secondaryTextColor = context.theme.appColors.secondaryText;
    final trackHeight = 4.0.s;

    return ColoredBox(
      color: backgroundColor ?? context.theme.appColors.primaryText,
      child: SliderTheme(
        data: SliderThemeData(
          thumbShape: const _CustomSliderComponentShape(),
          overlayShape: const _CustomSliderComponentShape(),
          trackHeight: trackHeight,
          trackShape: const RectangularSliderTrackShape(),
        ),
        child: Slider(
          max: duration.inMilliseconds.toDouble(),
          value: position.inMilliseconds.toDouble(),
          onChangeStart: onChangeStart,
          onChangeEnd: onChangeEnd,
          onChanged: onChanged,
          activeColor: secondaryBackgroundColor,
          inactiveColor: secondaryTextColor,
        ),
      ),
    );
  }
}

class _CustomSliderComponentShape extends SliderComponentShape {
  const _CustomSliderComponentShape();
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(0.s, 24.s);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    // no-op.
  }
}
