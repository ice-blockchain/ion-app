import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class PlusIcon extends StatelessWidget {
  PlusIcon({
    double? size,
  }) : size = size ?? 18.0.s;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.25.s,
              color: context.theme.appColors.secondaryBackground,
            ),
            color: context.theme.appColors.primaryAccent,
            shape: BoxShape.circle,
          ),
        ),
        ImageIcon(
          size: size,
          color: context.theme.appColors.secondaryBackground,
          AssetImage(Assets.images.icons.iconPlusCreatechannel.path),
        ),
      ],
    );
  }
}
