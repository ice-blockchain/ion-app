import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

extension IconExtension on AssetGenImage {
  Widget icon({Color? color, double? size}) {
    return SizedBox(
      width: size ?? 24.0.s,
      height: size ?? 24.0.s,
      child: FittedBox(
        child: ImageIcon(AssetImage(path), color: color),
      ),
    );
  }
}
