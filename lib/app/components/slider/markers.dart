import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';

class Markers extends HookWidget {
  const Markers({
    required this.stops,
    required this.sliderValue,
    required this.markerSize,
    required this.markerRadius,
  });

  final List<double> stops;
  final double sliderValue;
  final double markerSize;
  final double markerRadius;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stops.map((double stop) {
        return Container(
          width: markerSize.s,
          height: markerSize.s,
          decoration: BoxDecoration(
            color: stop <= sliderValue
                ? context.theme.appColors.primaryAccent
                : context.theme.appColors.onTerararyFill,
            borderRadius: BorderRadius.circular(markerRadius.s),
          ),
        );
      }).toList(),
    );
  }
}
