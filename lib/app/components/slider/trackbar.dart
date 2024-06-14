import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

class TrackBar extends StatelessWidget {
  const TrackBar.active({
    required this.trackBarHeight,
    required this.color,
    required this.width,
  })  : inactive = false,
        super();

  const TrackBar.inactive({
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
