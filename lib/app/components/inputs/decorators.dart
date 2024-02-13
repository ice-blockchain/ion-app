import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

class RoundedContainer extends Container {
  RoundedContainer({
    super.key,
    super.child,
    double? radius,
    Color? color,
    BoxBorder? border,
    EdgeInsets super.padding = EdgeInsets.zero,
    EdgeInsets super.margin = EdgeInsets.zero,
    super.width,
    super.height,
  }) : super(
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.all(
              Radius.circular(radius ?? 16.0.s),
            ),
            color: color,
          ),
        );
}
