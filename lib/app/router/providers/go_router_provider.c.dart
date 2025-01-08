// SPDX-License-Identifier: ice License 1.0

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_provider.c.dart';
import 'package:ion/app/features/auth/views/pages/link_new_device/link_new_device_dialog.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/core/providers/init_provider.c.dart';
import 'package:ion/app/features/core/providers/splash_provider.c.dart';
import 'package:ion/app/features/core/views/pages/error_page.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_router_listenable.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/ui_event_queue/ui_event_queue_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_provider.c.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
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
    debugLogDiagnostics: ref.watch(featureFlagsProvider.notifier).get(LoggerFeatureFlag.logRouters),
    navigatorKey: rootNavigatorKey,
  );
}

Future<String?> _mainRedirect({
  required String location,
  required Ref ref,
}) async {
  final hasAuthenticated = (ref.read(authProvider).valueOrNull?.hasAuthenticated).falseOrValue;
  final onboardingComplete = ref.read(onboardingCompleteProvider).valueOrNull;
  final hasNotificationsPermission = ref.read(hasPermissionProvider(Permission.notifications));

  final isOnSplash = location.startsWith(SplashRoute().location);
  final isOnAuth = location.contains('/${AuthRoutes.authPrefix}/');
  final isOnOnboarding = location.contains('/${AuthRoutes.onboardingPrefix}/');

  if (!hasAuthenticated && !isOnAuth) {
    return IntroRoute().location;
  }

  if (hasAuthenticated && onboardingComplete != null) {
    if (onboardingComplete) {
      if (isOnSplash || isOnAuth) {
        return FeedRoute().location;
      } else if (isOnOnboarding) {
        if (hasNotificationsPermission) {
          return FeedRoute().location;
        } else {
          return NotificationsRoute().location;
        }
      }
    }

    if (!onboardingComplete && !isOnOnboarding) {
      if (location == FeedRoute().location) {
        return null;
      }
      final userMetadata = await ref.read(currentUserMetadataProvider.future);
      if (userMetadata != null) {
        ref.read(uiEventQueueNotifierProvider.notifier).emit(const ShowLinkNewDeviceDialogEvent());
        return FeedRoute().location;
      }
      return FillProfileRoute().location;
    }
  }
  return null;
}
