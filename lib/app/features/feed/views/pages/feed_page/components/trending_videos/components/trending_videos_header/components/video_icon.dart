import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class VideosIcon extends StatelessWidget {
  const VideosIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0.s,
      height: 29.0.s,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.bg.iconStroke.path),
          fit: BoxFit.cover,
        ),
      ),
      child: ImageIcon(
        AssetImage(Assets.images.icons.iconVideosTrading.path),
        color: context.theme.appColors.secondaryBackground,
        size: 20.0.s,
      ),
    );
  }
}
