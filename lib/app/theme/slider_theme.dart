import 'package:flutter/material.dart';
import 'package:ice/app/theme/app_colors.dart';

SliderThemeData buildSliderTheme(AppColorsExtension colors) {
  return SliderThemeData(
    activeTrackColor: colors.primaryAccent,
    inactiveTrackColor: colors.onTerararyFill,
    thumbColor: colors.primaryAccent,
    overlayColor: colors.primaryAccent.withAlpha(32),
    trackHeight: 2.0,
    tickMarkShape: const RoundSliderTickMarkShape(),
    activeTickMarkColor: colors.primaryAccent,
    inactiveTickMarkColor: colors.onTerararyFill,
  );
}
