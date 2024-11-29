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
    super.key,
  });

  final Duration duration;
  final Duration position;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        thumbShape: SliderComponentShape.noThumb,
        overlayShape: SliderComponentShape.noThumb,
        trackHeight: 4.0.s,
        trackShape: const RectangularSliderTrackShape(),
      ),
      child: Slider(
        max: duration.inMilliseconds.toDouble(),
        value: position.inMilliseconds.toDouble(),
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        onChanged: onChanged,
        activeColor: context.theme.appColors.secondaryBackground,
        inactiveColor: context.theme.appColors.secondaryText,
      ),
    );
  }
}
