import 'package:go_router/go_router.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/core/providers/init_provider.dart';
import 'package:ice/app/features/core/providers/splash_provider.dart';
import 'package:ice/app/router/app_router_listenable.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/main_tab_navigation.dart';
import 'package:ice/app/router/providers/bottom_sheet_state_provider.dart';
import 'package:ice/app/router/utils/router_utils.dart';
import 'package:ice/app/services/logger/config.dart';
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
      final isAnimationCompleted = ref.read(splashProvider);

      final isSplash = state.matchedLocation == SplashRoute().location;
      final isInitInProgress = initState.isLoading;
      final isInitError = initState.hasError;
      final isInitCompleted = initState.hasValue;

      if (isInitError) {
        return ErrorRoute().location;
      }

      if (isInitInProgress && !isSplash) {
        return SplashRoute().location;
      }

      if (isInitCompleted && isSplash && isAnimationCompleted) {
        return switch (authState) {
          Authenticated() => FeedRoute().location,
          UnAuthenticated() => IntroRoute().location,
          _ => null
        };
      }

      if (state.matchedLocation.endsWith('-main-modal')) {
        return _handleModalRedirect(ref, state);
      }

      return switch (authState) {
        Authenticated()
            when state.matchedLocation.startsWith(IntroRoute().location) =>
          FeedRoute().location,
        UnAuthenticated()
            when !state.matchedLocation.startsWith(IntroRoute().location) =>
          IntroRoute().location,
        _ => null
      };
    },
    routes: $appRoutes,
    errorBuilder: (context, state) =>
        ErrorRoute($extra: state.error).build(context, state),
    initialLocation: SplashRoute().location,
    debugLogDiagnostics: LoggerConfig.routerLogsEnabled,
    navigatorKey: rootNavigatorKey,
  );
}

String? _handleModalRedirect(GoRouterRef ref, GoRouterState state) {
  final bottomSheetState = ref.read(bottomSheetStateProvider);
  final currentTab = getCurrentTab(state.matchedLocation);
  if (!bottomSheetState[currentTab]!) {
    return switch (currentTab) {
      TabItem.feed => FeedRoute().location,
      TabItem.chat => ChatRoute().location,
      TabItem.dapps => DappsRoute().location,
      TabItem.wallet => WalletRoute().location,
      TabItem.main => null,
    };
  }
  return null;
}
