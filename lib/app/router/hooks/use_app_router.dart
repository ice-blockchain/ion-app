import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/router/app_router_listenable.dart';
import 'package:ice/app/router/routing_utils.dart';
import 'package:ice/app/services/logger/config.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter useAppRouter(WidgetRef ref) {
  final notifier = ref.watch(appRouterListenableProvider.notifier);

  final GoRouter router = useMemoized(
    () => GoRouter(
      refreshListenable: notifier,
      debugLogDiagnostics: LoggerConfig.routerLogsEnabled,
      routes: appRoutes,
      redirect: notifier.redirect,
      navigatorKey: _rootNavigatorKey,
    ),
    <AppRouterListenable>[notifier],
  );

  return router;
}
