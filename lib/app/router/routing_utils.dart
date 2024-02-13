import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/list.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/views/scaffold_with_bottom_sheet.dart';
import 'package:ice/app/router/views/scaffold_with_nested_navigation.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';

List<RouteBase> get appRoutes {
  return iceRootRoutes.map(_convertIntoRoute).toList();
}

typedef WidgetBuilder = Widget Function();

RouteBase _convertIntoRoute(
  IceRoutes route, {
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
    pageBuilder: _providePageBuilder<void>(route, parentType),
    routes: _buildChildren(route),
  );
}

GoRouterPageBuilder _providePageBuilder<T>(
  IceRoutes route,
  IceRouteType? parentType,
) {
  Widget widgetBuild(GoRouterState state) => route.builder(route, state.extra);

  Page<T> simple(BuildContext context, GoRouterState state) => CupertinoPage<T>(
        key: state.pageKey,
        child: widgetBuild(state),
      );

  Page<T> bottomSheet(BuildContext context, GoRouterState state) =>
      _buildPageWithFadeTransition<T>(
        state: state,
        child: widgetBuild(state),
      );

  return switch (parentType) {
    null => simple,
    IceRouteType.single => simple,
    IceRouteType.bottomSheet => bottomSheet,
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

List<RouteBase> _buildChildren(IceRoutes route) {
  final List<IceRoutes> children = route.children.emptyOrValue;
  if (children.isEmpty) {
    return const <RouteBase>[];
  }

  GlobalKey<NavigatorState>? parentNavigatorKey;

  late final List<RouteBase> Function(List<RouteBase> children) processChildren;

  switch (route.type) {
    case IceRouteType.single:
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

  final List<RouteBase> childrenRoutes = children
      .map(
        (IceRoutes child) => _convertIntoRoute(
          child,
          parentType: route.type == IceRouteType.bottomTabs ? null : route.type,
          parentNavigatorKey: parentNavigatorKey,
        ),
      )
      .toList();

  return processChildren(childrenRoutes);
}

WidgetBuilder
    _convertToWidgetBuilder<PayloadType, PageType extends IcePage<PayloadType>>(
  IceRoutes route,
  GoRouterState state,
) {
  return () => route.builder(route, state.extra);
}

List<RouteBase> _buildBottomSheetShellRoute<T>(
  IceRoutes route,
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

RouteBase _buildBottomTabsRoute<T>(IceRoutes route) {
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
