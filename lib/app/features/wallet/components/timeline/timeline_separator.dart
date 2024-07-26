import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class TimelineSeparator extends StatelessWidget {
  const TimelineSeparator({
    Key? key,
    this.color = Colors.transparent,
  }) : super(key: key);

  final Color color;

  static double get separatorWidth => 1.0.s;
  static double get separatorHeight => 18.0.s;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: separatorWidth,
      height: separatorHeight,
      color: color,
    );
  }
}
