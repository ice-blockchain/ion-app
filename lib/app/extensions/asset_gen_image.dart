import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

extension IconExtension on AssetGenImage {
  Widget icon({Color? color, double? size}) {
    final double iconSize = size ?? 24.0.s;
    return Image.asset(
      path,
      width: iconSize,
      height: iconSize,
      excludeFromSemantics: true,
      fit: BoxFit.contain,
      color: color,
    );
  }
}
