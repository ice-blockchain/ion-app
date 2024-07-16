import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/router/components/modal_wrapper/modal_wrapper2.dart';
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
    // final sheetController = DefaultSheetController.of(context);
    // final metrics = sheetController.value;

    return switch (type) {
      IceRouteType.single => CupertinoPage<void>(child: child),
      IceRouteType.bottomSheet => ScrollableNavigationSheetPage<void>(
          child: child,
          // minExtent: metrics.hasDimensions
          //     ? Extent.pixels(metrics.minPixels)
          //     : const Extent.proportional(0),
        ),
      IceRouteType.slideFromLeft =>
        SlideFromLeftTransitionPage(child: child, state: state),
      IceRouteType.modalSheet => ModalSheetPage(
          swipeDismissible: true,
          child: ModalWrapper2(child: child),
        ),
      // CupertinoPage(
      //   key: state.pageKey,
      //   child: DraggableSheet(
      //     child: ModalWrapper2(child: child),
      //   ),
      // ),
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
