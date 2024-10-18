// SPDX-License-Identifier: ice License 1.0

import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_provider.dart';
import 'package:ion/app/features/core/providers/init_provider.dart';
import 'package:ion/app/features/core/providers/splash_provider.dart';
import 'package:ion/app/features/core/views/pages/error_page.dart';
import 'package:ion/app/router/app_router_listenable.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/services/logger/config.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_provider.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  GoRouter.optionURLReflectsImperativeAPIs = true;

  return GoRouter(
    refreshListenable: AppRouterNotifier(ref),
    redirect: (context, state) async {
      final initState = ref.read(initAppProvider);
      final isSplashAnimationCompleted = ref.read(splashProvider);

      final isInitInProgress = initState.isLoading;
      final isInitError = initState.hasError;

      if (isInitError) {
        Logger.log('Init error', error: initState.error);
        return ErrorRoute().location;
      }

      if (isInitInProgress || !isSplashAnimationCompleted) {
        // Redirect if app is not initialized yet
        return SplashRoute().location;
      }

      return _mainRedirect(location: state.matchedLocation, ref: ref);
    },
    routes: $appRoutes,
    errorBuilder: (context, state) => ErrorPage(error: state.error ?? Exception('Unknown error')),
    initialLocation: SplashRoute().location,
    debugLogDiagnostics: LoggerConfig.routerLogsEnabled,
    navigatorKey: rootNavigatorKey,
  );
}

FutureOr<String?> _mainRedirect({
  required String location,
  required ProviderRef<GoRouter> ref,
}) {
  final hasAuthenticated = (ref.read(authProvider).valueOrNull?.hasAuthenticated).falseOrValue;
  final onboardingComplete = ref.read(onboardingCompleteProvider).valueOrNull;

  final isOnSplash = location.startsWith(SplashRoute().location);
  final isOnAuth = location.contains('/${AuthRoutes.authPrefix}/');
  final isOnOnboarding = location.contains('/${AuthRoutes.onboardingPrefix}/');

  if (!hasAuthenticated && !isOnAuth) {
    return IntroRoute().location;
  }

  if (hasAuthenticated && onboardingComplete != null) {
    if (onboardingComplete && (isOnSplash || isOnAuth)) {
      return FeedRoute().location;
    }

    if (!onboardingComplete && !isOnOnboarding) {
      return FillProfileRoute().location;
    }
  }
  return null;
}
