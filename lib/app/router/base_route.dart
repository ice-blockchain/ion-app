import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

enum IceRouteType {
  single,
  bottomSheet,
  slideFromLeft,
}

abstract class BaseRouteData extends GoRouteData {
  BaseRouteData({
    required this.child,
    this.transitionType = IceRouteType.single,
  });
  final IceRouteType transitionType;

  final Widget child;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return switch (transitionType) {
      IceRouteType.single => CupertinoPage<void>(child: child),
      IceRouteType.bottomSheet => ScrollableNavigationSheetPage(
          initialExtent: const Extent.proportional(0.5),
          minExtent: const Extent.proportional(0.3),
          maxExtent: const Extent.proportional(0.8),
          key: state.pageKey,
          child: child,
        ),
      IceRouteType.slideFromLeft =>
        SlideFromLeftTransitionPage(child: child, state: state),
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
