import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/string.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthHeaderWidget extends StatelessWidget {
  AuthHeaderWidget({
    this.title = '',
    double? topPadding,
    String? imagePath,
    this.description,
  })  : topPadding = topPadding ?? 65.0.s,
        imagePath = imagePath ?? Assets.images.logo.logoIce.path;

  final double topPadding;
  final String title;
  final String? description;
  final String imagePath;

  static double get iconSide => 65.0.s;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Image.asset(
            imagePath,
            width: iconSide,
            height: iconSide,
            fit: BoxFit.fitWidth,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 19.0.s),
          child: Text(
            title,
            style: context.theme.appTextThemes.headline1.copyWith(
              color: context.theme.appColors.primaryText,
            ),
          ),
        ),
        if (description.isNotEmpty)
          Text(
            description!,
            textAlign: TextAlign.center,
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.tertararyText,
            ),
          ),
      ],
    );
  }
}
