import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/router/components/sheet_content/main_modal_content.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

enum IceRouteType {
  single,
  bottomSheet,
  slideFromLeft,
  mainModalSheet,
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
      IceRouteType.mainModalSheet => ModalSheetPage<void>(
          swipeDismissible: true,
          key: state.pageKey,
          // DraggableSheet does not work with scrollable widgets.
          // If you want to use a scrollable widget as its content,
          // use ScrollableSheet instead.
          // See example in smooth_sheets package.
          child: DraggableSheet(
            controller: DefaultSheetController.of(context),
            child: MainModalContent(
              state: state,
              child: child,
            ),
          ),
        ),
    };
  }
}

class FadeTransitionSheetPage extends ScrollableNavigationSheetPage<void> {
  FadeTransitionSheetPage({
    required super.child,
    required GoRouterState state,
  }) : super(
          key: state.pageKey,
          physics: BouncingSheetPhysics(
            behavior: DirectionAwareBouncingBehavior(
              upward: Extent.pixels(0),
            ),
          ),
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
