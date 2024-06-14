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
  });

  final List<double> stops;
  final ValueNotifier<double> sliderValue;
  final double markerSize;
  final double markerRadius;
  final Function(double) onMarkerTapped;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> sliderValueNotifier =
        useValueNotifier(sliderValue.value);

    useEffect(
      () {
        void listener() => sliderValueNotifier.value = sliderValue.value;
        sliderValue.addListener(listener);
        return () => sliderValue.removeListener(listener);
      },
      <Object?>[sliderValue],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stops.map((double stop) {
        return GestureDetector(
          onTap: () => onMarkerTapped(stop),
          child: AnimatedBuilder(
            animation: sliderValueNotifier,
            builder: (BuildContext context, Widget? child) {
              return Container(
                width: markerSize.s,
                height: markerSize.s,
                decoration: BoxDecoration(
                  color: stop <= sliderValueNotifier.value
                      ? context.theme.appColors.primaryAccent
                      : context.theme.appColors.onTerararyFill,
                  borderRadius: BorderRadius.circular(markerRadius.s),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
