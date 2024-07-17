import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class AuthHeader extends StatelessWidget {
  AuthHeader({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.showBackButton = true,
    double? iconOffset,
    double? descriptionSidePadding,
  })  : iconOffset = iconOffset ?? 19.0.s,
        descriptionSidePadding = descriptionSidePadding ?? 0.0.s;

  final String? title;
  final String? description;
  final Widget? icon;
  final double iconOffset;
  final double descriptionSidePadding;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavigationAppBar.modal(
          showBackButton: showBackButton,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0.s),
          child: Column(
            children: [
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(bottom: iconOffset),
                  child: icon,
                ),
              if (title?.isNotEmpty ?? false)
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: context.theme.appTextThemes.headline1.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
              if (description.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(
                    left: descriptionSidePadding,
                    right: descriptionSidePadding,
                    top: 8.0.s,
                  ),
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
