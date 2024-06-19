import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ArticleHeader extends StatelessWidget {
  const ArticleHeader({
    required this.headerText,
    super.key,
    this.isMainHeader = false,
  });

  final String headerText;
  final bool isMainHeader;

  TextStyle getStyle(BuildContext context) {
    final color = context.theme.appColors.sharkText;
    if (isMainHeader) {
      return context.theme.appTextThemes.headline2.copyWith(color: color);
    }
    return context.theme.appTextThemes.title.copyWith(color: color);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Text(
        headerText,
        style: getStyle(context),
      ),
    );
  }
}
