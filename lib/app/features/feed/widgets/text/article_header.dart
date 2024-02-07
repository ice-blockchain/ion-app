import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/shared/widgets/core/screen_side_offset.dart';

class ArticleHeader extends StatelessWidget {
  const ArticleHeader({super.key, required this.headerText, this.main});

  final String headerText;
  final bool? main;

  TextStyle getStyle(BuildContext context) {
    if (main == true) {
      return context.theme.appTextThemes.headline2
          .copyWith(color: context.theme.appColors.feedText);
    }
    return context.theme.appTextThemes.title
        .copyWith(color: context.theme.appColors.feedText);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset(
      child: Text(
        headerText,
        style: getStyle(context),
      ),
    );
  }
}
