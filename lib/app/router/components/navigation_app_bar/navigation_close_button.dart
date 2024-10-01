// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class NavigationCloseButton extends StatelessWidget {
  const NavigationCloseButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ??
          () {
            final state = GoRouterState.of(context);
            context.go(state.currentTab.baseRouteLocation);
          },
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Assets.svg.iconSheetClose.icon(
          color: context.theme.appColors.tertararyText,
        ),
      ),
    );
  }
}
