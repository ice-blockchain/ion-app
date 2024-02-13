import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  final Map<IceRoutes, String> _routesLocations = <IceRoutes, String>{};

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

  String _location(IceRoutes route, GoRouterState state) {
    final String? location = _routesLocations[route];
    if (location == null) {
      return _routesLocations[route] =
          state.namedLocation(route.name); //TODO avoid hardcoded route.name
    }

    return location;
  }

  // ignore: avoid_build_context_in_providers
  String? redirect(BuildContext context, GoRouterState state) {
    final IceRoutes? route = _redirectNamed(state);
    if (route != null) {
      return _location(route, state);
    }

    return null;
  }

  IceRoutes? _redirectNamed(GoRouterState state) {
    //TODO: check that its part of intro navigation flow
    final bool isAuthInProgress =
        state.matchedLocation.startsWith(_location(IceRoutes.intro, state));
    final bool isSplash =
        state.matchedLocation == _location(IceRoutes.splash, state);
    final bool isInitError = _init?.hasError ?? false;
    final bool isInitInProgress = _init?.isLoading ?? true;
    final bool isAnimationCompleted = ref.watch(splashProvider);

    if (isInitError) {
      return IceRoutes.splash;
    }

    if (isInitInProgress && !isSplash || !isAnimationCompleted) {
      return IceRoutes.splash;
    }

    if (isSplash && !isInitInProgress && isAnimationCompleted) {
      if (_authState is Authenticated) {
        return IceRoutes.wallet;
      }
      if (_authState is UnAuthenticated) {
        /// Navigate to the Intro screen after splash for unauthenticated users
        return IceRoutes.intro;
      }
    }

    if (isAuthInProgress && _authState is Authenticated) {
      return IceRoutes.wallet;
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
}
