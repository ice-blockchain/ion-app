import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/components/arrival_time/slider_utils.dart';
import 'package:ice/generated/assets.gen.dart';

class ArrivalTimeSlider extends HookWidget {
  const ArrivalTimeSlider({
    this.initialValue = 15.0,
    this.stops = const <double>[0, 15, 30, 45],
    required this.onChanged,
    this.maxValue = 45.0,
    this.minValue = 0.0,
    this.stepValue = 15.0,
    this.handlerHeight = 40.0,
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
  final double handlerHeight;
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
            height: 50.0.s,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _TrackBar.inactive(
                  trackBarHeight: trackBarHeight,
                  color: context.theme.appColors.onTerararyFill,
                ),
                Positioned(
                  left: 0,
                  child: _TrackBar.active(
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
                _Markers(
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
                  child: _SliderThumb(
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

class _Markers extends StatelessWidget {
  const _Markers({
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

class _SliderThumb extends StatelessWidget {
  const _SliderThumb({
    required this.sliderValue,
    required this.sliderWidth,
    required this.onChanged,
    required this.thumbIconSize,
    required this.maxValue,
    required this.minValue,
  });

  final ValueNotifier<double> sliderValue;
  final double sliderWidth;
  final Function(double) onChanged;
  final double thumbIconSize;
  final double maxValue;
  final double minValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        final double newValue = SliderUtils.calculateNewValueOnDrag(
          currentValue: sliderValue.value,
          deltaDx: details.delta.dx,
          sliderWidth: sliderWidth,
          minValue: minValue,
          maxValue: maxValue,
        );
        sliderValue.value = newValue;
        onChanged(sliderValue.value);
      },
      child: Assets.images.icons.iconBlockRocket.icon(
        size: thumbIconSize.s,
      ),
    );
  }
}

class _TrackBar extends StatelessWidget {
  const _TrackBar.active({
    required this.trackBarHeight,
    required this.color,
    required this.width,
  })  : inactive = false,
        super();

  const _TrackBar.inactive({
    required this.trackBarHeight,
    required this.color,
  })  : width = double.infinity,
        inactive = true,
        super();

  final double trackBarHeight;
  final Color color;
  final double width;
  final bool inactive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: trackBarHeight.s,
      color: color,
      width: inactive ? double.infinity : width,
    );
  }
}
