import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/views/scaffold_with_bottom_sheet.dart';
import 'package:ice/app/utils/extensions.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorBottomSheetKey = GlobalKey<NavigatorState>(debugLabel: 'bottomSheet');

List<RouteBase> get appRoutes {
  return iceRoots.map(_convertIntoRoute).toList();
}

RouteBase _convertIntoRoute(
  IcePages page, {
  IcePageType? parentType,
  GlobalKey<NavigatorState>? parentNavigatorKey,
}) {
  final bool initial = page == initialPage;

  final String path = initial
      ? '/'
      : parentType == null
          ? '/${page.name}'
          : page.name;
  final String name = page.name;
  return GoRoute(
    path: path,
    name: name,
    parentNavigatorKey: parentNavigatorKey,
    pageBuilder: _providePageBuilder<void>(page, parentType),
    routes: _buildChildren(page),
  );
}

GoRouterPageBuilder _providePageBuilder<T>(IcePages page, IcePageType? parentType) {
  final Widget body = page.builder();

  Page<T> simple(BuildContext context, GoRouterState state) => CupertinoPage<T>(
        key: state.pageKey,
        child: body,
      );

  Page<T> bottomSheet(BuildContext context, GoRouterState state) => _buildPageWithFadeTransition<T>(
        state: state,
        child: body,
      );

  Page<T> bottomTabs(BuildContext context, GoRouterState state) => NoTransitionPage<T>(
    key: state.pageKey,
    child: body,
  );

  return switch (parentType) {
    null => simple,
    IcePageType.single => simple,
    IcePageType.bottomSheet => bottomSheet,
    IcePageType.bottomTabs => bottomTabs,
  };
}

CustomTransitionPage<T> _buildPageWithFadeTransition<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder:
        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) =>
            FadeTransition(opacity: animation, child: child),
  );
}

List<RouteBase> _buildChildren(IcePages page) {
  final List<IcePages> children = page.children.emptyOrValue;
  if (children.isEmpty) {
    return const <RouteBase>[];
  }

  GlobalKey<NavigatorState>? parentNavigatorKey;

  late final List<RouteBase> Function(List<RouteBase> children) processChildren;

  switch (page.type) {
    case IcePageType.single:
      processChildren = (List<RouteBase> children) => children;
    case IcePageType.bottomSheet:
      parentNavigatorKey = _shellNavigatorBottomSheetKey;
      processChildren = (List<RouteBase> children) => _buildBottomSheetShellRoute(
            children,
            parentNavigatorKey,
            page.builder,
          );
    case IcePageType.bottomTabs:
      throw UnimplementedError(); //TODO
  }

  final List<RouteBase> childrenRoutes = children
      .map(
        (IcePages child) => _convertIntoRoute(
          child,
          parentType: page.type,
          parentNavigatorKey: parentNavigatorKey,
        ),
      )
      .toList();

  return processChildren(childrenRoutes);
}

List<RouteBase> _buildBottomSheetShellRoute<T>(
  List<RouteBase> children,
  GlobalKey<NavigatorState>? shellNavigatorKey,
  Widget Function() builder,
) {
  return <RouteBase>[
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      pageBuilder: (BuildContext context, GoRouterState state, Widget child) => NoTransitionPage<T>(
        key: state.pageKey,
        child: ScaffoldWithBottomSheet(
          builder: builder,
          child: child,
        ),
      ),
      routes: children,
    ),
  ];
}
