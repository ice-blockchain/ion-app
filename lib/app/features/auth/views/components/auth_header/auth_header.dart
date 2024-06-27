import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/string.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class AuthHeader extends StatelessWidget {
  AuthHeader({
    super.key,
    this.title,
    this.description = '',
    this.icon,
    this.showBackButton = true,
    double? iconOffset,
  }) : iconOffset = iconOffset ?? 19.0.s;

  final String? title;
  final String? description;
  final Widget? icon;
  final double iconOffset;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NavigationAppBar.modal(
          showBackButton: showBackButton,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0.s),
          child: Column(
            children: <Widget>[
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(bottom: iconOffset),
                  child: icon,
                ),
              if (title.isNotEmpty)
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: context.theme.appTextThemes.headline1.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
              if (description.isNotEmpty) SizedBox(height: 8.0.s),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0.s),
                child: Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.tertararyText,
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
