import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class Markers extends StatelessWidget {
  const Markers({
    required this.stops,
    required this.sliderValue,
    required this.markerSize,
    required this.markerRadius,
  });

  final List<double> stops;
  final ValueNotifier<double> sliderValue;
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
            color: stop <= sliderValue.value
                ? context.theme.appColors.primaryAccent
                : context.theme.appColors.onTerararyFill,
            borderRadius: BorderRadius.circular(markerRadius.s),
          ),
        );
      }).toList(),
    );
  }
}
