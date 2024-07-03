import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/router/components/modal_wrapper/modal_wrapper.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';

enum IceRouteType {
  single,
  bottomSheet,
  slideFromLeft,
}

abstract class BaseRouteData extends GoRouteData {
  BaseRouteData({
    this.transitionType = IceRouteType.single,
    this.sheetFit = SheetFit.loose,
  });
  final IceRouteType transitionType;
  final SheetFit sheetFit;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final child = build(context, state);
    return switch (transitionType) {
      IceRouteType.single => CupertinoPage<void>(child: child),
      IceRouteType.bottomSheet => SheetPage<void>(
          fit: sheetFit,
          key: state.pageKey,
          child: ModalWrapper(child: child),
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
