import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/list.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/views/scaffold_with_bottom_sheet.dart';
import 'package:ice/app/router/views/scaffold_with_nested_navigation.dart';

List<RouteBase> get appRoutes {
  final Iterable<RouteBase> iterable =
      iceRootRoutes.map(<T>(IceRoutes<T> route) => _convertIntoRoute<T>(route));
  return iterable.toList();
}

typedef WidgetBuilder = Widget Function();

RouteBase _convertIntoRoute<T>(
  IceRoutes<T> route, {
  IceRouteType? parentType,
  GlobalKey<NavigatorState>? parentNavigatorKey,
}) {
  if (route.type == IceRouteType.bottomTabs) {
    return _buildBottomTabsRoute(route);
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
    pageBuilder: _providePageBuilder<T>(route, parentType),
    routes: _buildChildren<T>(route),
  );
}

GoRouterPageBuilder _providePageBuilder<T>(
  IceRoutes<T> route,
  IceRouteType? parentType,
) {
  Widget widgetBuild(GoRouterState state) {
    return route.builder(route, state.extra);
  }

  Page<T> simple(BuildContext context, GoRouterState state) => CupertinoPage<T>(
        key: state.pageKey,
        child: widgetBuild(state),
      );

  Page<T> bottomSheet(BuildContext context, GoRouterState state) =>
      _buildPageWithFadeTransition<T>(
        state: state,
        child: widgetBuild(state),
      );

  Page<T> slideFromLeft(BuildContext context, GoRouterState state) =>
      _buildPageWithSlideFromLeftTransition<T>(
        state: state,
        child: widgetBuild(state),
      );

  return switch (parentType) {
    null => simple,
    IceRouteType.single => simple,
    IceRouteType.bottomSheet => bottomSheet,
    IceRouteType.slideFromLeft => slideFromLeft,
    IceRouteType.bottomTabs =>
      throw Exception('should be built in a different way'),
  };
}

CustomTransitionPage<T> _buildPageWithFadeTransition<T>({
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
    ) =>
        FadeTransition(opacity: animation, child: child),
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

  GlobalKey<NavigatorState>? parentNavigatorKey;

  late final List<RouteBase> Function(List<RouteBase> children) processChildren;

  switch (route.type) {
    case IceRouteType.single:
    case IceRouteType.slideFromLeft:
    case IceRouteType.bottomTabs:
      processChildren = (List<RouteBase> children) => children;
    case IceRouteType.bottomSheet:
      parentNavigatorKey =
          GlobalKey<NavigatorState>(debugLabel: 'bottomSheet ${route.name}');
      processChildren =
          (List<RouteBase> children) => _buildBottomSheetShellRoute(
                route,
                children,
                parentNavigatorKey,
              );
  }

  final Iterable<RouteBase> iterable = children.map(
    <T>(IceRoutes<T> child) => _convertIntoRoute<T>(
      child,
      parentType: route.type == IceRouteType.bottomTabs ? null : route.type,
      parentNavigatorKey: parentNavigatorKey,
    ),
  );
  final List<RouteBase> childrenRoutes = iterable.toList();

  return processChildren(childrenRoutes);
}

WidgetBuilder
    _convertToWidgetBuilder<PayloadType, PageType extends IcePage<PayloadType>>(
  IceRoutes<PayloadType> route,
  GoRouterState state,
) {
  return () => route.builder(route, state.extra as PayloadType?);
}

List<RouteBase> _buildBottomSheetShellRoute<T>(
  IceRoutes<T> route,
  List<RouteBase> children,
  GlobalKey<NavigatorState>? shellNavigatorKey,
) {
  return <RouteBase>[
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      pageBuilder: (BuildContext context, GoRouterState state, Widget child) =>
          NoTransitionPage<T>(
        key: state.pageKey,
        child: ScaffoldWithBottomSheet(
          builder: _convertToWidgetBuilder(route, state),
          child: child,
        ),
      ),
      routes: children,
    ),
  ];
}

RouteBase _buildBottomTabsRoute<T>(IceRoutes<T> route) {
  final List<RouteBase> children = _buildChildren(route);

  return StatefulShellRoute.indexedStack(
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
