import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/shared/widgets/button/button.dart';
import 'package:ice/generated/assets.gen.dart';

class Socials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = context.theme.iconButtonTheme.style?.iconSize
            ?.resolve(<MaterialState>{}) ??
        defaultIconButtonSide;
    final double spaceBetweenButtons =
        (screenWidth - 2 * defaultEdgeInset - 4 * buttonWidth) / 3;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(
            4,
            (int index) => Button.outlinedIconButton(
              context: context,
              onPressed: () {},
              imagePath: Assets.images.facebook.path,
            ),
          ),
        ),
        SizedBox(height: spaceBetweenButtons),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(
            4,
            (int index) => Button.outlinedIconButton(
              context: context,
              onPressed: () {},
              imagePath: Assets.images.x.path,
            ),
          ),
        ),
      ],
    );
  }
}
