// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

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
            /// TODO(@ion-endymion): replace it with [Navigator.of(context, rootNavigator: true).pop()]
            /// after test this approach with other modals
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
