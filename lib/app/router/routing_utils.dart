import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/modal_wrapper/modal_wrapper.dart';
import 'package:ice/app/extensions/list.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/views/scaffold_with_nested_navigation.dart';

List<RouteBase> get appRoutes {
  final Iterable<RouteBase> iterable =
      iceRootRoutes.map(<T>(IceRoutes<T> route) => _convertIntoRoute<T>(route));
  return iterable.toList();
}

RouteBase _convertIntoRoute<T>(
  IceRoutes<T> route, {
  IceRouteType? parentType,
  GlobalKey<NavigatorState>? parentNavigatorKey,
}) {
  final List<RouteBase> children = _buildChildren(route);

  if (route.type == IceRouteType.bottomTabs) {
    return _buildBottomTabsRoute(route, parentNavigatorKey, children);
  } else if (route.type == IceRouteType.bottomSheet) {
    return _buildBottomSheetRoute(route, parentNavigatorKey, children);
  }

  final bool initial = route == initialPage;

  final String path = initial
      ? '/'
      : parentType == null
          ? '/${route.name}'
          : route.name;
  final String name = route.name;

  return GoRoute(
    path: path,
    name: name,
    parentNavigatorKey: parentNavigatorKey,
    pageBuilder: _providePageBuilder<T>(route),
    routes: children,
  );
}

RouteBase _buildBottomSheetRoute<T>(
  IceRoutes<T> route,
  GlobalKey<NavigatorState>? parentNavigatorKey,
  List<RouteBase> children,
) {
  return ShellRoute(
    parentNavigatorKey: parentNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state, _) =>
        DialogPage<T>(state: state),
    routes: children,
  );
}

GoRouterPageBuilder _providePageBuilder<T>(IceRoutes<T> route) {
  Widget widgetBuild(GoRouterState state) {
    final Widget? widget = route.builder?.call(route, state.extra);
    return widget ?? const SizedBox.shrink();
  }

  Page<T> simple(BuildContext context, GoRouterState state) => CupertinoPage<T>(
        key: state.pageKey,
        child: widgetBuild(state),
      );

  Page<T> slideFromLeft(BuildContext context, GoRouterState state) =>
      _buildPageWithSlideFromLeftTransition<T>(
        state: state,
        child: widgetBuild(state),
      );

  if (route.type == IceRouteType.slideFromLeft) {
    return slideFromLeft;
  }

  return simple;
}

CustomTransitionPage<T> _buildPageWithSlideFromLeftTransition<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      final Animation<Offset> offsetAnimation = Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(animation);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

List<RouteBase> _buildChildren<T>(IceRoutes<T> route) {
  final List<IceRoutes<dynamic>> children = route.children.emptyOrValue;
  if (children.isEmpty) {
    return const <RouteBase>[];
  }

  final Iterable<RouteBase> iterable = children.map(
    <T>(IceRoutes<T> child) => _convertIntoRoute<T>(
      child,
      parentType: route.type == IceRouteType.bottomTabs ? null : route.type,
    ),
  );

  return iterable.toList();
}

class DialogPage<T> extends Page<T> {
  const DialogPage({
    required this.state,
  });

  final GoRouterState state;

  @override
  Route<T> createRoute(BuildContext context) => BottomSheetRoute<T>(
        settings: this,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return ModalWrapper(payload: state.extra);
        },
      );
}

class BottomSheetRoute<T> extends ModalBottomSheetRoute<T> {
  BottomSheetRoute({
    required super.builder,
    required super.isScrollControlled,
    super.settings,
    super.constraints,
    super.backgroundColor,
  });

  @override
  bool get canPop {
    return false;
  }
}

RouteBase _buildBottomTabsRoute<T>(
  IceRoutes<T> route,
  GlobalKey<NavigatorState>? parentNavigatorKey,
  List<RouteBase> children,
) {
  return StatefulShellRoute.indexedStack(
    parentNavigatorKey: parentNavigatorKey,
    builder: (
      BuildContext context,
      GoRouterState state,
      StatefulNavigationShell navigationShell,
    ) {
      return ScaffoldWithNestedNavigation(
        key: state.pageKey,
        navigationShell: navigationShell,
      );
    },
    branches: children.map(_convertIntoBranch).toList(),
  );
}

StatefulShellBranch _convertIntoBranch(RouteBase route) {
  return StatefulShellBranch(
    navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'bottomTab'),
    routes: <RouteBase>[route],
  );
}
