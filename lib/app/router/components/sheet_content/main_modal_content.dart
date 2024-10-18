// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/go_router_state.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class MainModalContent extends StatelessWidget {
  const MainModalContent({required this.child, required this.state, super.key});

  final Widget child;
  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    final controller = DefaultSheetController.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final metrics = controller.value;

          if (metrics.hasDimensions) {
            context.go(state.currentTab.baseRouteLocation);
          }
        }
      },
      child: child,
    );
  }
}
