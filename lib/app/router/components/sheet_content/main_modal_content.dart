import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/router/utils/route_utils.dart';
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
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final metrics = controller.value;

          if (metrics.hasDimensions) {
            final currentTab = getCurrentTab(state.matchedLocation);
            context.go(getBaseRouteLocation(currentTab));
          }
        }
      },
      child: child,
    );
  }
}
