import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/slider/slider.dart';
import 'package:ice/app/extensions/extensions.dart';

class AppSlider extends HookWidget {
  const AppSlider({
    this.initialValue = 15.0,
    this.stops = const <double>[0, 15, 30, 45],
    required this.onChanged,
    this.maxValue = 45.0,
    this.minValue = 0.0,
    this.stepValue = 15.0,
    this.sliderHeight = 40.0,
    this.trackBarHeight = 2.0,
    this.thumbIconSize = 34.0,
    this.markerSize = 8.0,
    this.markerRadius = 3.0,
  });

  final double initialValue;
  final List<double> stops;
  final Function(double) onChanged;
  final double maxValue;
  final double minValue;
  final double stepValue;
  final double sliderHeight;
  final double trackBarHeight;
  final double thumbIconSize;
  final double markerSize;
  final double markerRadius;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> sliderValue = useState(initialValue);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double sliderWidth = constraints.maxWidth;

        return GestureDetector(
          onPanUpdate: (DragUpdateDetails details) => _handlePanUpdate(
            context,
            details,
            sliderWidth,
            sliderValue,
          ),
          child: SizedBox(
            width: sliderWidth,
            height: sliderHeight.s,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                TrackBar.inactive(
                  trackBarHeight: trackBarHeight,
                  color: context.theme.appColors.onTerararyFill,
                ),
                Positioned(
                  left: 0.0.s,
                  child: TrackBar.active(
                    trackBarHeight: trackBarHeight,
                    color: context.theme.appColors.primaryAccent,
                    width: SliderUtils.calculateActiveTrackWidth(
                      value: sliderValue.value,
                      minValue: minValue,
                      maxValue: maxValue,
                      sliderWidth: sliderWidth,
                    ).s,
                  ),
                ),
                Markers(
                  stops: stops,
                  sliderValue: sliderValue,
                  markerSize: markerSize.s,
                  markerRadius: markerRadius.s,
                ),
                Positioned(
                  left: SliderUtils.computeSliderOffset(
                    value: sliderValue.value,
                    minValue: minValue,
                    maxValue: maxValue,
                    sliderWidth: sliderWidth,
                    thumbSize: thumbIconSize.s,
                    leftOffset: -2.5.s,
                    rightOffset: -1.0.s,
                  ),
                  child: SliderThumb(
                    sliderValue: sliderValue,
                    sliderWidth: sliderWidth,
                    onChanged: onChanged,
                    thumbIconSize: thumbIconSize.s,
                    maxValue: maxValue,
                    minValue: minValue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handlePanUpdate(
    BuildContext context,
    DragUpdateDetails details,
    double sliderWidth,
    ValueNotifier<double> sliderValue,
  ) {
    final Offset localPosition = SliderUtils.getLocalPosition(
      context,
      details.globalPosition,
    );
    final double newValue = SliderUtils.calculateNewValue(
      localPosition: localPosition,
      sliderWidth: sliderWidth,
      minValue: minValue,
      maxValue: maxValue,
    );
    sliderValue.value = newValue;
    onChanged(sliderValue.value);
  }
}
