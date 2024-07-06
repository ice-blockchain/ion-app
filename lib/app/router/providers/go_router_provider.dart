import 'package:go_router/go_router.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/core/providers/init_provider.dart';
import 'package:ice/app/features/core/providers/splash_provider.dart';
import 'package:ice/app/router/app_router_listenable.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/services/logger/config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_provider.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  final authState = ref.watch(authProvider);
  final initState = ref.watch(initAppProvider);
  final isAnimationCompleted = ref.watch(splashProvider);

  return GoRouter(
    refreshListenable: ref.read(appRouterListenableProvider.notifier),
    redirect: (context, state) {
      final isSplash = state.matchedLocation == SplashRoute().location;
      final isAuthenticated = authState is Authenticated;
      final isUnAuthenticated = authState is UnAuthenticated;
      final isAuthUnknown = authState is AuthenticationUnknown;
      final isAuthLoading = authState is AuthenticationLoading;
      final isInitInProgress = initState.isLoading;
      final isInitError = initState.hasError;
      final isInitCompleted = initState.hasValue;

      if (isInitError) {
        return '/error';
      }

      if (isInitInProgress && !isSplash) {
        return SplashRoute().location;
      }

      if (isInitCompleted && isSplash && isAnimationCompleted) {
        if (isAuthenticated) {
          return FeedRoute().location;
        }
        if (isUnAuthenticated) {
          return IntroRoute().location;
        }
      }

      if (isAuthLoading || isAuthUnknown) {
        return null;
      }

      // if (isUnAuthenticated && state.matchedLocation != '/intro') {
      //   return '/intro';
      // }

      if (isAuthenticated && state.matchedLocation == IntroRoute().location) {
        return FeedRoute().location;
      }

      return null;
    },
    routes: $appRoutes,
    errorBuilder: (context, state) =>
        ErrorRoute($extra: state.error).build(context, state),
    initialLocation: SplashRoute().location,
    debugLogDiagnostics: LoggerConfig.routerLogsEnabled,
    navigatorKey: rootNavigatorKey,
  );
}
