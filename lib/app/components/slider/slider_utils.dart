import 'dart:ui';

import 'package:flutter/material.dart';

/// A utility class for slider-related calculations and conversions.
class SliderUtils {
  SliderUtils._();

  /// Converts a global position to a local position within the given context.
  ///
  /// [context] is the BuildContext of the widget.
  /// [globalPosition] is the global position to convert.
  static Offset getLocalPosition(BuildContext context, Offset globalPosition) {
    final RenderBox box = context.findRenderObject()! as RenderBox;
    return box.globalToLocal(globalPosition);
  }

  /// Calculates the new slider value based on the local position.
  ///
  /// [localPosition] is the local position within the slider.
  /// [sliderWidth] is the total width of the slider.
  /// [minValue] is the minimum value of the slider.
  /// [maxValue] is the maximum value of the slider.
  static double calculateNewValue({
    required Offset localPosition,
    required double sliderWidth,
    required double minValue,
    required double maxValue,
  }) {
    final double newValue =
        (localPosition.dx / sliderWidth) * (maxValue - minValue) + minValue;
    return newValue.clamp(minValue, maxValue);
  }

  /// Computes the offset for the slider thumb based on the current value.
  ///
  /// [value] is the current value of the slider.
  /// [minValue] is the minimum value of the slider.
  /// [maxValue] is the maximum value of the slider.
  /// [sliderWidth] is the total width of the slider.
  /// [thumbSize] is the size of the slider thumb.
  /// [leftOffset] is the additional offset for the left edge to account for
  /// the empty pixels around the border of the thumb image.
  /// [rightOffset] is the additional offset for the right edge to account for
  /// the empty pixels around the border of the thumb image.
  static double computeSliderOffset({
    required double value,
    required double minValue,
    required double maxValue,
    required double sliderWidth,
    required double thumbSize,
    required double leftOffset,
    required double rightOffset,
  }) {
    final double offset =
        ((value - minValue) / (maxValue - minValue) * sliderWidth) -
            (thumbSize / 2);
    return offset.clamp(leftOffset, sliderWidth - thumbSize - rightOffset);
  }

  /// Calculates the width of the active track based on the current value.
  ///
  /// [value] is the current value of the slider.
  /// [minValue] is the minimum value of the slider.
  /// [maxValue] is the maximum value of the slider.
  /// [sliderWidth] is the total width of the slider.
  static double calculateActiveTrackWidth({
    required double value,
    required double minValue,
    required double maxValue,
    required double sliderWidth,
  }) {
    return sliderWidth * ((value - minValue) / (maxValue - minValue));
  }

  /// Calculates the new slider value based on a horizontal drag.
  ///
  /// [currentValue] is the current value of the slider.
  /// [deltaDx] is the horizontal drag distance.
  /// [sliderWidth] is the total width of the slider.
  /// [minValue] is the minimum value of the slider.
  /// [maxValue] is the maximum value of the slider.
  static double calculateNewValueOnDrag({
    required double currentValue,
    required double deltaDx,
    required double sliderWidth,
    required double minValue,
    required double maxValue,
  }) {
    final double newValue =
        currentValue + (deltaDx / sliderWidth) * (maxValue - minValue);
    return newValue.clamp(minValue, maxValue);
  }

  /// Finds the closest stop to the current value.
  ///
  /// [currentValue] is the current value of the slider.
  /// [stops] is the list of stop values.
  /// [resistance] is the resistance factor for interpolation.
  static double findClosestStop({
    required double currentValue,
    required List<double> stops,
    required double resistance,
  }) {
    final int closestStopIndex =
        stops.indexWhere((double stop) => stop >= currentValue);

    if (closestStopIndex == -1) {
      return stops.last;
    } else if (closestStopIndex == 0) {
      return stops.first;
    } else {
      final double previousStop = stops[closestStopIndex - 1];
      final double nextStop = stops[closestStopIndex];
      final double midPoint = (previousStop + nextStop) / 2;

      return (currentValue < midPoint)
          ? lerpDouble(currentValue, previousStop, resistance)!
          : lerpDouble(currentValue, nextStop, resistance)!;
    }
  }

  /// Adjusts the slider value to the closest stop after dragging ends.
  ///
  /// [currentValue] is the current value of the slider.
  /// [stops] is the list of stop values.
  static double adjustToClosestStop({
    required double currentValue,
    required List<double> stops,
  }) {
    final int closestStopIndex =
        stops.indexWhere((double stop) => stop >= currentValue);

    if (closestStopIndex == -1) {
      return stops.last;
    } else if (closestStopIndex == 0) {
      return stops.first;
    } else {
      final double previousStop = stops[closestStopIndex - 1];
      final double nextStop = stops[closestStopIndex];
      final double midPoint = (previousStop + nextStop) / 2;

      return (currentValue < midPoint) ? previousStop : nextStop;
    }
  }
}
