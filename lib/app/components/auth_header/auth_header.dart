import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthHeaderWidget extends StatelessWidget {
  AuthHeaderWidget({
    this.topPadding = 65.0,
    this.bottomPadding = 30.0,
    this.title = '',
    String? description,
    String? imagePath,
  })  : description = description ?? '', // Ensure description is not null
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
          padding: const EdgeInsets.only(top: 19, bottom: 3),
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
