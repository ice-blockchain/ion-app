// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';

class AuthHeaderIcon extends StatelessWidget {
  AuthHeaderIcon({
    super.key,
    this.icon,
    double? size,
  }) : size = size ?? 65.0.s;

  final Widget? icon;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.theme.appColors.primaryAccent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: icon,
      ),
    );
  }
}
