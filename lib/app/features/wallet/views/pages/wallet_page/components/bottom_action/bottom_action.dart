import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class BottomAction extends StatelessWidget {
  const BottomAction({
    super.key,
    required this.onTap,
    required this.asset,
    required this.title,
  });

  final VoidCallback onTap;
  final AssetGenImage asset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenSideOffset.defaultSmallMargin,
        right: ScreenSideOffset.defaultSmallMargin,
        bottom: 16.0.s,
        top: 12.0.s,
      ),
      child: Button(
        leadingIcon: asset.image(width: 24.0.s, height: 24.0.s),
        onPressed: onTap,
        label: Text(
          title,
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
        mainAxisSize: MainAxisSize.max,
        type: ButtonType.secondary,
      ),
    );
  }
}
