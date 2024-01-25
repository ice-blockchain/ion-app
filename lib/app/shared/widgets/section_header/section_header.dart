import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    this.topPadding = 24.0,
    this.bottomPadding = 16.0,
    this.title = '',
    this.onPress,
  });

  final double topPadding;
  final double bottomPadding;
  final String title;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        height: 24,
        padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Visibility(
              visible: title.isNotEmpty,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: context.theme.appTextThemes.subtitle.copyWith(
                  color: context.theme.appColors.primaryText,
                ),
              ),
            ),
            if (onPress != null)
              IconButton(
                icon: Image.asset(
                  Assets.images.buttonNext.path,
                  width: 24,
                  height: 24,
                ),
                onPressed: onPress,
              ),
          ],
        ),
      ),
    );
  }
}
