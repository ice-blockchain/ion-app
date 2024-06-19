import 'package:flutter/material.dart';
import 'package:ice/app/components/slider/slider_utils.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

class SliderThumb extends StatelessWidget {
  const SliderThumb({
    required this.sliderValue,
    required this.sliderWidth,
    required this.onChanged,
    required this.thumbIconSize,
    required this.maxValue,
    required this.minValue,
    required this.stops,
    required this.resistance,
    super.key,
  });

  final ValueNotifier<double> sliderValue;
  final double sliderWidth;
  final void Function(double) onChanged;
  final double thumbIconSize;
  final double maxValue;
  final double minValue;
  final List<double> stops;
  final double resistance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        final newValue = SliderUtils.calculateNewValueOnDrag(
          currentValue: sliderValue.value,
          deltaDx: details.delta.dx,
          sliderWidth: sliderWidth,
          minValue: minValue,
          maxValue: maxValue,
        );
        sliderValue.value = newValue;
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        sliderValue.value = SliderUtils.adjustToClosestStop(
          currentValue: sliderValue.value,
          stops: stops,
        );
        onChanged(sliderValue.value);
      },
      child: Assets.images.icons.iconBlockRocket.icon(
        size: thumbIconSize.s,
      ),
    );
  }
}
