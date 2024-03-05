import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/router/app_router_listenable.dart';
import 'package:ice/app/router/routing_utils.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter useAppRouter(WidgetRef ref) {
  final AppRouterListenable notifier =
      ref.watch(appRouterListenableProvider.notifier);

  final GoRouter router = useMemoized(
    () => GoRouter(
      refreshListenable: notifier,
      debugLogDiagnostics: true,
      routes: appRoutes,
      redirect: notifier.redirect,
      navigatorKey: rootNavigatorKey,
    ),
    <AppRouterListenable>[notifier],
  );

  return router;
}
