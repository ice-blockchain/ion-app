// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';

class AuthHeader extends StatelessWidget {
  AuthHeader({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.titleStyle,
    this.descriptionStyle,
    double? topOffset,
    double? iconOffset,
    double? descriptionSidePadding,
  })  : topOffset = topOffset ?? 5.0.s,
        iconOffset = iconOffset ?? 20.0.s,
        descriptionSidePadding = descriptionSidePadding ?? 0.0.s;

  final String? title;
  final String? description;
  final Widget? icon;
  final double topOffset;
  final double iconOffset;
  final double descriptionSidePadding;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: topOffset),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.0.s),
          child: Column(
            children: [
              if (icon != null)
                Padding(
                  padding: EdgeInsetsDirectional.only(bottom: iconOffset),
                  child: icon,
                ),
              if (title?.isNotEmpty ?? false)
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: titleStyle ??
                      context.theme.appTextThemes.headline1.copyWith(
                        color: context.theme.appColors.primaryText,
                      ),
                ),
              if (description.isNotEmpty)
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: descriptionSidePadding,
                    end: descriptionSidePadding,
                    top: 8.0.s,
                  ),
                  child: Text(
                    description!,
                    textAlign: TextAlign.center,
                    style: descriptionStyle ??
                        context.theme.appTextThemes.body2.copyWith(
                          color: context.theme.appColors.tertiaryText,
                        ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
