import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArrivalTimeSlider extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> currentSliderValue = useState(15.0);
    const int divisions = 3;
    const double max = 35;
    const double min = 5;

    return Slider(
      value: currentSliderValue.value,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: (double value) {
        currentSliderValue.value = value;
      },
    );
  }
}
