import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/router/app_router_listenable.dart';
import 'package:ice/app/router/app_routes.dart';

GoRouter useAppRouter(WidgetRef ref) {
  final AppRouterListenable notifier =
      ref.watch(appRouterListenableProvider.notifier);

  final GoRouter router = useMemoized(
    () => GoRouter(
      initialLocation: const SplashRoute().location,
      refreshListenable: notifier,
      debugLogDiagnostics: true,
      routes: $appRoutes,
      redirect: notifier.redirect,
      navigatorKey: rootNavigatorKey,
    ),
    <AppRouterListenable>[notifier],
  );

  return router;
}
