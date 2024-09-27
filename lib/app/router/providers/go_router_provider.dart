import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/core/providers/init_provider.dart';
import 'package:ice/app/features/core/providers/splash_provider.dart';
import 'package:ice/app/features/core/views/pages/error_page.dart';
import 'package:ice/app/router/app_router_listenable.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/services/logger/config.dart';
import 'package:ice/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_provider.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  GoRouter.optionURLReflectsImperativeAPIs = true;

  return GoRouter(
    refreshListenable: AppRouterNotifier(ref),
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final initState = ref.read(initAppProvider);
      final isSplashAnimationCompleted = ref.read(splashProvider);

      final isInitInProgress = initState.isLoading;
      final isInitError = initState.hasError;
      final hasAuthenticated = (authState.valueOrNull?.hasAuthenticated).falseOrValue;

      if (isInitError) {
        Logger.log('Init error', error: initState.error);
        return ErrorRoute().location;
      }

      if (isInitInProgress || !isSplashAnimationCompleted) {
        // Redirect if app is not initialized yet
        return SplashRoute().location;
      }

      if (state.matchedLocation.startsWith(SplashRoute().location)) {
        // Redirect after app init complete
        return hasAuthenticated ? FeedRoute().location : IntroRoute().location;
      }

      // Redirects when user log in / out
      if (hasAuthenticated && state.matchedLocation.startsWith(IntroRoute().location)) {
        return FeedRoute().location;
      } else if (!hasAuthenticated && !state.matchedLocation.startsWith(IntroRoute().location)) {
        return IntroRoute().location;
      }

      return null;
    },
    routes: $appRoutes,
    errorBuilder: (context, state) => ErrorPage(error: state.error ?? Exception('Unknown error')),
    initialLocation: SplashRoute().location,
    debugLogDiagnostics: LoggerConfig.routerLogsEnabled,
    navigatorKey: rootNavigatorKey,
  );
}
