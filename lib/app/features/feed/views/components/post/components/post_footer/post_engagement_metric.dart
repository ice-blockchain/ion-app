import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class PostEngagementMetric extends StatelessWidget {
  const PostEngagementMetric({
    required this.icon,
    required this.onPressed,
    super.key,
    this.value,
  });

  static double get horizontalHitSlop => 12.0.s;
  static double get verticalHitSlop => 6.0.s;

  final Widget icon;
  final VoidCallback onPressed;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalHitSlop,
          horizontal: horizontalHitSlop,
        ),
        child: Row(
          children: <Widget>[
            IconTheme(
              data: IconThemeData(
                size: 16.0.s,
                color: context.theme.appColors.onTertararyBackground,
              ),
              child: icon,
            ),
            if (value != null)
              Padding(
                padding: EdgeInsets.only(left: 4.0.s),
                child: Text(
                  value!,
                  style: context.theme.appTextThemes.caption2.copyWith(
                    color: context.theme.appColors.onTertararyBackground,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
