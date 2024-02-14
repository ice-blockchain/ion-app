import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class SectionHeader extends StatelessWidget {
  SectionHeader({
    this.title,
    this.onPress,
    double? topPadding,
    double? bottomPadding,
  })  : topPadding = topPadding ?? 24.0.s,
        bottomPadding = bottomPadding ?? 16.0.s;

  final double topPadding;
  final double bottomPadding;
  final String? title;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding,
          bottom: bottomPadding,
        ),
        child: SizedBox(
          height: 24.0.s,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (title != null && title!.isNotEmpty)
                Text(
                  title!,
                  textAlign: TextAlign.left,
                  style: context.theme.appTextThemes.subtitle.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
              if (onPress != null)
                // TODO::why not Button component
                InkWell(
                  onTap: onPress,
                  child: Ink(
                    width: 24.0.s, // Set the width of the button
                    height: 24.0.s, // Set the height of the button
                    child: Center(
                      child: Image.asset(
                        Assets.images.icons.iconButtonNext.path,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
