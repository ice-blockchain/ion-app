import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ListTileTitle extends StatelessWidget {
  const ListTileTitle({
    super.key,
    required this.label,
  });

  final Widget label;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: context.theme.appTextThemes.body
          .copyWith(color: context.theme.appColors.primaryText),
      child: label,
    );
  }
}
