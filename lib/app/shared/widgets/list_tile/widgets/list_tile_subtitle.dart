import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ListTileSubtitle extends StatelessWidget {
  const ListTileSubtitle({
    super.key,
    required this.label,
  });

  final Widget label;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: context.theme.appTextThemes.caption3
          .copyWith(color: context.theme.appColors.secondaryText),
      child: label,
    );
  }
}
