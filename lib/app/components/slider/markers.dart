// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';

class Markers extends HookWidget {
  const Markers({
    required this.stops,
    required this.sliderValue,
    required this.markerSize,
    required this.markerRadius,
    required this.onMarkerTapped,
    super.key,
  });

  final List<double> stops;
  final ValueNotifier<double> sliderValue;
  final double markerSize;
  final double markerRadius;
  final void Function(double) onMarkerTapped;

  @override
  Widget build(BuildContext context) {
    final double currentSliderValue = useValueListenable(sliderValue);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stops.map((double stop) {
        return GestureDetector(
          onTap: () => onMarkerTapped(stop),
          child: Container(
            width: markerSize.s,
            height: markerSize.s,
            decoration: BoxDecoration(
              color: stop <= currentSliderValue
                  ? context.theme.appColors.primaryAccent
                  : context.theme.appColors.onTerararyFill,
              borderRadius: BorderRadius.circular(markerRadius.s),
            ),
          ),
        );
      }).toList(),
    );
  }
}
