import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class LinksListTileDivider extends StatelessWidget {
  const LinksListTileDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.5.s,
      color: context.theme.appColors.onTerararyFill,
    );
  }
}
