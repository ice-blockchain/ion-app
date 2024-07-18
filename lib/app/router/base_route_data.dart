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
      IceRouteType.bottomSheet => ScrollableNavigationSheetPage<void>(
          child: child,
        ),
      IceRouteType.slideFromLeft =>
        SlideFromLeftTransitionPage(child: child, state: state),
      IceRouteType.mainModalSheet => ModalSheetPage<void>(
          swipeDismissible: true,
          key: state.pageKey,
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
