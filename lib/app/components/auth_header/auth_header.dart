import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthHeaderWidget extends StatelessWidget {
  AuthHeaderWidget({
    this.title = '',
    double? topPadding,
    double? bottomPadding,
    String? description,
    String? imagePath,
  })  : topPadding = topPadding ?? 65.0.s,
        bottomPadding = bottomPadding ?? 30.0.s,
        description = description ?? '', // Ensure description is not null
        imagePath = imagePath ?? Assets.images.iceRound.path;

  final double topPadding;
  final double bottomPadding;
  final String title;
  final String description;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Image.asset(
            imagePath,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 19.0.s, bottom: 3.0.s),
          child: Text(
            title,
            style: context.theme.appTextThemes.headline1,
          ),
        ),
        Visibility(
          visible: description
              .isNotEmpty, // Show the Text widget only if description is not empty
          child: Text(
            description,
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.tertararyText,
            ),
          ),
        ),
        SizedBox(
          height: bottomPadding,
        ),
      ],
    );
  }
}
