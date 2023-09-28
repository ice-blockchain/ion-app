import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/nested_navigator_wrapper.dart';

@TypedGoRoute<AuthFlowRoute>(
  path: '/',
)
class AuthFlowRoute extends GoRouteData {
  const AuthFlowRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final List<GoRouteData> subroutes = <GoRouteData>[
      const IntroRoute(),
      const AuthRoute(),
    ];

    final List<Page<void>> pages =
        subroutes.map((GoRouteData e) => e.buildPage(context, state)).toList();

    return MaterialPage<void>(
      child: NestedNavigatorWrapper(
        navigatorKey: GlobalKey<
            NavigatorState>(), // you can store and manage this key if needed
        pages: pages,
      ),
    );
  }
}
