import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class ClosableModalHeader extends StatelessWidget {
  const ClosableModalHeader({
    super.key,
    required this.title,
  });

  final String title;

  static double get hitSlop => 8.0.s;

  static double get verticalPadding => 20.0.s;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Text(
            title,
            style: context.theme.appTextThemes.subtitle,
          ),
        ),
        Positioned(
          right: ScreenSideOffset.defaultSmallMargin - hitSlop,
          top: verticalPadding - hitSlop,
          child: TextButton(
            child: Padding(
              padding: EdgeInsets.all(hitSlop),
              child: Assets.images.icons.iconSheetClose.icon(
                color: context.theme.appColors.tertararyText,
              ),
            ),
            onPressed: () => context.pop(),
          ),
        ),
      ],
    );
  }
}
