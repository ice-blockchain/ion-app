import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

extension IconExtension on AssetGenImage {
  Widget icon({Color? color, double? size}) {
    return ImageIcon(
      AssetImage(path),
      color: color,
      size: size ?? 24.0.s,
    );
  }
}
