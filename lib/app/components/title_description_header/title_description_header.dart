import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class TitleDescription extends StatelessWidget {
  TitleDescription({
    this.title = '',
    this.description = '',
    double? topPadding,
    double? bottomPadding,
  })  : topPadding = topPadding ?? 0,
        bottomPadding = bottomPadding ?? 16.s;

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
            padding: EdgeInsets.only(top: topPadding, bottom: 8.s),
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
              padding: EdgeInsets.symmetric(horizontal: 52.s),
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
