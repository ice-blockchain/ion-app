import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/string.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/core/providers/init_provider.dart';
import 'package:ice/app/features/core/providers/splash_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router_listenable.g.dart';

/// Inspired by https://github.com/lucavenir/go_router_riverpod

@riverpod
class AppRouterListenable extends _$AppRouterListenable implements Listenable {
  VoidCallback? _routerListener;
  AuthState _authState = const AuthenticationUnknown();
  AsyncValue<void>? _init;

  final Map<IceRoutes<dynamic>, String?> _routesLocations =
      <IceRoutes<dynamic>, String?>{};

  // ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
  @override
  Future<void> build() async {
    _authState = ref.watch(authProvider);
    _init = ref.watch(initAppProvider);

    ref.listenSelf((_, __) {
      if (state.isLoading) {
        return;
      }
      _routerListener?.call();
    });
  }

  String? _location(IceRoutes<dynamic> route, GoRouterState state) {
    if (_routesLocations.containsKey(route)) {
      return _routesLocations[route];
    }

    String? foundLocation;

    try {
      foundLocation = state.namedLocation(route.routeName);
    } catch (_) {}

    return _routesLocations[route] = foundLocation;
  }

  // ignore: avoid_build_context_in_providers
  String? redirect(BuildContext context, GoRouterState goRouterState) {
    final currentRoute = _getCurrentRoute(goRouterState);
    final route = _redirectNamed(goRouterState, currentRoute);
    late final IceRoutes<dynamic>? routeResult;
    String? resultLocation;
    if (route != null) {
      routeResult = route;
      resultLocation = _location(route, goRouterState);
    } else {
      routeResult = currentRoute;
    }

    if (routeResult != initialPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(currentRouteProvider.notifier).route = routeResult!;
      });
    }

    return resultLocation;
  }

  IceRoutes<dynamic>? _redirectNamed(
    GoRouterState goRouterState,
    IceRoutes<dynamic> currentRoute,
  ) {
    //TODO: check that its part of intro navigation flow
    final isAuthInProgress = goRouterState.matchedLocation
        .startsWith(_location(IceRoutes.intro, goRouterState).emptyOrValue);
    final isSplash = currentRoute == initialPage;
    final isInitError = _init?.hasError ?? false;
    final isInitInProgress = _init?.isLoading ?? true;
    final isAnimationCompleted = ref.watch(splashProvider);

    if (isInitError) {
      return IceRoutes.error;
    }

    if (isInitInProgress && !isSplash || !isAnimationCompleted) {
      return initialPage;
    }

    if (isSplash && !isInitInProgress && isAnimationCompleted) {
      if (_authState is Authenticated) {
        return IceRoutes.feed;
      }
      if (_authState is UnAuthenticated) {
        /// Navigate to the Intro screen after splash for unauthenticated users
        return IceRoutes.intro;
      }
    }

    if (isAuthInProgress && _authState is Authenticated) {
      return IceRoutes.feed;
    }

    if (!isAuthInProgress && _authState is UnAuthenticated) {
      return IceRoutes.intro;
    }

    return null;
  }

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerListener = null;
  }

  IceRoutes<dynamic> _getCurrentRoute(GoRouterState state) {
    for (final route in IceRoutes.values) {
      try {
        if (state.matchedLocation == _location(route, state)) {
          return route;
        }
      } catch (_) {}
    }

    return initialPage;
  }
}

@Riverpod(keepAlive: true)
class CurrentRoute extends _$CurrentRoute {
  @override
  IceRoutes<dynamic> build() => initialPage;

  set route(IceRoutes<dynamic> route) {
    state = route;
  }
}
