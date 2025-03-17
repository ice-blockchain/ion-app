// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/router/components/modal_wrapper/dismissible_content.dart';
import 'package:ion/app/router/components/sheet_content/main_modal_content.dart';
import 'package:ion/app/utils/future.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

enum IceRouteType {
  single,
  bottomSheet,
  slideFromLeft,
  fade,
  mainModalSheet,
  simpleModalSheet,
  swipeDismissible,
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
      IceRouteType.bottomSheet => FadeTransitionSheetPage(child: child, state: state),
      IceRouteType.slideFromLeft => SlideFromLeftTransitionPage(child: child, state: state),
      IceRouteType.fade => FadeTransitionPage(child: child, state: state),
      IceRouteType.mainModalSheet =>
        MainModalSheetPage(child: child, state: state, context: context),
      IceRouteType.simpleModalSheet =>
        ScrollableModalSheetPageRoute(child: child, state: state, context: context),
      IceRouteType.swipeDismissible => SwipeDismissiblePageRoute(child: child, state: state),
    };
  }
}

class FadeTransitionSheetPage extends ScrollableNavigationSheetPage<void> {
  FadeTransitionSheetPage({
    required super.child,
    required GoRouterState state,
  }) : super(
          key: state.pageKey,
          physics: const ClampingSheetPhysics(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeInTween = TweenSequence<double>([
              TweenSequenceItem(tween: ConstantTween(0), weight: 1),
              TweenSequenceItem(
                tween: Tween<double>(begin: 0, end: 1).chain(
                  CurveTween(curve: Curves.easeIn),
                ),
                weight: 1,
              ),
            ]);

            return FadeTransition(
              opacity: animation.drive(fadeInTween),
              child: child,
            );
          },
        );
}

class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({
    required super.child,
    required GoRouterState state,
  }) : super(
          key: state.pageKey,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
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

class MainModalSheetPage extends ModalSheetPage<void> {
  MainModalSheetPage({
    required Widget child,
    required GoRouterState state,
    required BuildContext context,
  }) : super(
          swipeDismissible: true,
          barrierColor: context.theme.appColors.backgroundSheet,
          key: state.pageKey,
          swipeDismissSensitivity: const SwipeDismissSensitivity(
            minDragDistance: 100,
            minFlingVelocityRatio: 1.5,
          ),
          // DraggableSheet does not work with scrollable widgets.
          // If you want to use a scrollable widget as its content,
          // use ScrollableSheet instead.
          // See example in smooth_sheets package.
          child: DraggableSheet(
            controller: DefaultSheetController.of(context),
            physics: const ClampingSheetPhysics(),
            child: MainModalContent(
              state: state,
              child: child,
            ),
          ),
        );
}

class ScrollableModalSheetPageRoute extends ModalSheetPage<void> {
  ScrollableModalSheetPageRoute({
    required Widget child,
    required GoRouterState state,
    required BuildContext context,
  }) : super(
          swipeDismissible: true,
          barrierColor: context.theme.appColors.backgroundSheet,
          key: state.pageKey,
          child: ScrollableSheet(
            controller: DefaultSheetController.of(context),
            physics: const SnappingSheetPhysics(),
            child: MainModalContent(
              state: state,
              child: child,
            ),
          ),
        );
}

class SwipeDismissiblePageRoute extends CustomTransitionPage<void> {
  SwipeDismissiblePageRoute({
    required Widget child,
    required GoRouterState state,
  }) : super(
          key: state.pageKey,
          fullscreenDialog: true,
          opaque: false,
          barrierColor: Colors.transparent,
          transitionDuration: 250.ms,
          reverseTransitionDuration: 250.ms,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: DismissibleContent(
            state: state,
            child: child,
          ),
        );
}
