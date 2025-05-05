// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class GlobalNotificationView extends StatelessWidget {
  const GlobalNotificationView({
    required this.message,
    required this.backgroundColor,
    this.icon,
    super.key,
  });

  final String message;
  final Color backgroundColor;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.0.s,
      child: ColoredBox(
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 8.0.s),
                  child: icon,
                ),
              Text(
                message,
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.onPrimaryAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
