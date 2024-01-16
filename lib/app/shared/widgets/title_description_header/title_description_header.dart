import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class TitleDescription extends StatelessWidget {
  const TitleDescription({
    this.topPadding = 0,
    this.bottomPadding = 16.0,
    String? title,
    String? description,
  })  : title = title ?? '',
        description = description ?? '';

  final double topPadding;
  final double bottomPadding;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: topPadding, bottom: 8),
            child: Visibility(
              visible: title.isNotEmpty,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: context.theme.appTextThemes.headline1.copyWith(
                  color: context.theme.appColors.primaryText,
                ),
              ),
            ),
          ),
          Visibility(
            visible: description.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 52),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.tertararyText,
                ),
              ),
            ),
          ),
          SizedBox(
            height: bottomPadding,
          ),
        ],
      ),
    );
  }
}
