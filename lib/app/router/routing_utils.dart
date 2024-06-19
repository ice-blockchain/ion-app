import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/list.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/modal_wrapper/modal_wrapper.dart';
import 'package:ice/app/router/main_tab_navigation.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

List<RouteBase> get appRoutes {
  final iterable = iceRootRoutes.map<RouteBase>(_convertIntoRoute);
  return iterable.toList();
}

RouteBase _convertIntoRoute<T>(
  IceRoutes<T> route, {
  IceRouteType? parentType,
  GlobalKey<NavigatorState>? parentNavigatorKey,
}) {
  final children = _buildChildren(route);

  if (route.type == IceRouteType.bottomTabs) {
    return _buildBottomTabsRoute(route, parentNavigatorKey, children);
  }

  final initial = route == initialPage;

  final path = initial
      ? '/'
      : parentType == null
          ? '/${route.name}'
          : route.name;
  final name = route.name;

  return GoRoute(
    path: path,
    name: name,
    parentNavigatorKey: parentNavigatorKey,
    pageBuilder: _providePageBuilder<T>(route),
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

  Page<T> bottomSheet(BuildContext context, GoRouterState state) =>
      _buildBottomSheetPage<T>(
        state: state,
        child: widgetBuild(state),
      );

  if (route.type == IceRouteType.slideFromLeft) {
    return slideFromLeft;
  } else if (route.type == IceRouteType.bottomSheet) {
    return bottomSheet;
  }

  return simple;
}

Page<T> _buildBottomSheetPage<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return ScrollableNavigationSheetPage<T>(
    key: state.pageKey,
    child: child,
  );
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
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(-1, 0),
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
  final pages = <IceRoutes<dynamic>>[];
  final bottomSheets = <IceRoutes<dynamic>>[];
  for (final child in route.children.emptyOrValue) {
    if (child.type == IceRouteType.bottomSheet) {
      bottomSheets.add(child);
    } else {
      pages.add(child);
    }
  }

  final routes = _convertChildrenIntoRoutes<dynamic>(pages, route.type);

  if (bottomSheets.isNotEmpty) {
    final bottomSheetsRoutes = _convertChildrenIntoRoutes<dynamic>(
      bottomSheets,
      route.type,
    );
    final bottomSheetRoute =
        _buildBottomSheetRoute(children: bottomSheetsRoutes);
    routes.add(bottomSheetRoute);
  }

  return routes;
}

RouteBase _buildBottomSheetRoute({
  required List<RouteBase> children,
}) {
  final navigationSheetTransitionObserver = NavigationSheetTransitionObserver();
  return ShellRoute(
    observers: <NavigatorObserver>[navigationSheetTransitionObserver],
    pageBuilder: (BuildContext context, GoRouterState state, Widget navigator) {
      return ModalSheetPage<dynamic>(
        child: ModalWrapper(
          navigator: navigator,
          transitionObserver: navigationSheetTransitionObserver,
        ),
      );
    },
    routes: children,
  );
}

List<RouteBase> _convertChildrenIntoRoutes<T>(
  List<IceRoutes<dynamic>> children,
  IceRouteType parentRouteType,
) {
  final iterable = children.map<RouteBase>(
    (child) => _convertChildIntoRoute(child, parentRouteType),
  );

  return iterable.toList();
}

RouteBase _convertChildIntoRoute<T>(
  IceRoutes<T> child,
  IceRouteType parentRouteType,
) {
  return _convertIntoRoute<T>(
    child,
    parentType:
        parentRouteType == IceRouteType.bottomTabs ? null : parentRouteType,
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
      return MainTabNavigation(
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
