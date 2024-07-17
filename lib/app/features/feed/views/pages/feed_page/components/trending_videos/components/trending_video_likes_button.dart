import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';

class TrendingVideoLikesButton extends StatelessWidget {
  const TrendingVideoLikesButton({
    required this.likes,
    required this.onPressed,
    super.key,
  });

  final int likes;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12.0.s),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Assets.images.icons.iconVideoLikeOn.icon(
            size: 14.0.s,
            color: context.theme.appColors.secondaryBackground,
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.0.s),
            child: Text(
              formatDoubleCompact(likes),
              style: context.theme.appTextThemes.caption3.copyWith(
                color: context.theme.appColors.secondaryBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
