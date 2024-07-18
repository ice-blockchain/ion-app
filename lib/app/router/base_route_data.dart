import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/providers/bottom_sheet_state_provider.dart';
import 'package:ice/app/router/utils/router_utils.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

enum IceRouteType {
  single,
  bottomSheet,
  slideFromLeft,
  modalSheet,
}

abstract class BaseRouteData extends GoRouteData {
  BaseRouteData({
    required this.child,
    this.type = IceRouteType.single,
  });
  final IceRouteType type;

  final Widget child;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return switch (type) {
      IceRouteType.single => CupertinoPage<void>(child: child),
      IceRouteType.bottomSheet => ScrollableNavigationSheetPage<void>(
          child: child,
        ),
      IceRouteType.slideFromLeft =>
        SlideFromLeftTransitionPage(child: child, state: state),
      IceRouteType.modalSheet => ModalSheetPage<void>(
          swipeDismissible: true,
          key: state.pageKey,
          child: DraggableSheet(
            controller: DefaultSheetController.of(context),
            // child: child,
            child: _ModalContent(
              state: state,
              child: child,
            ),
            // child: child,
          ),
        ),
    };
  }

  @override
  Widget build(BuildContext context, GoRouterState state);
}

class SlideFromLeftTransitionPage extends CustomTransitionPage<void> {
  SlideFromLeftTransitionPage({
    required super.child,
    required GoRouterState state,
  }) : super(
          key: state.pageKey,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1, 0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

class _ModalContent extends HookConsumerWidget {
  const _ModalContent({required this.child, required this.state});

  final Widget child;
  final GoRouterState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomSheetNotifier = ref.watch(bottomSheetStateProvider.notifier);
    final controller = DefaultSheetController.of(context);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final metrics = controller.value;
          if (!metrics.hasDimensions) {
            final currentTab = getCurrentTab(state.matchedLocation);
            bottomSheetNotifier.closeCurrentSheet(currentTab);
            popRoute();
          }
        });
        return null;
      },
      [],
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final controller = DefaultSheetController.of(context);
          final metrics = controller.value;

          log('_ModalContent - onPopInvoked: metrics: $metrics');

          if (!context.mounted) return;

          if (metrics.hasDimensions) {
            final currentTab = getCurrentTab(state.matchedLocation);
            log('_ModalContent - onPopInvoked: closing sheet for $currentTab');
            bottomSheetNotifier.closeCurrentSheet(currentTab);
            await popRoute();
          }
        }
      },
      child: child,
    );
  }
}
