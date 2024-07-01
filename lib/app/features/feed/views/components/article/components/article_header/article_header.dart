import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ArticleHeader extends StatelessWidget {
  const ArticleHeader({
    required this.text,
    super.key,
    this.isMainHeader = false,
  });

  final String text;

  final bool isMainHeader;

  TextStyle _getStyle(BuildContext context) {
    final color = context.theme.appColors.sharkText;
    if (isMainHeader) {
      return context.theme.appTextThemes.headline2.copyWith(color: color);
    }
    return context.theme.appTextThemes.title.copyWith(color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getStyle(context),
    );
  }
}
