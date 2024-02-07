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

  // ignore: avoid_build_context_in_providers
  String? redirect(BuildContext context, GoRouterState state) {
    final String? name = _redirectNamed(state);
    if (name != null) {

      return state.namedLocation(name);  //TODO cache all named locations

    }

    return null;
  }

  String? _redirectNamed(GoRouterState state) {
    //TODO: check that its part of intro navigation flow
    final bool isAuthInProgress = state.matchedLocation.startsWith(IcePages.intro.location(state));
    final bool isSplash = state.matchedLocation == IcePages.splash.location(state);
    final bool isInitError = _init?.hasError ?? false;
    final bool isInitInProgress = _init?.isLoading ?? true;
    final bool isAnimationCompleted = ref.watch(splashProvider);

    if (isInitError) {
      return IcePages.splash.name;
    }

    if (isInitInProgress && !isSplash || !isAnimationCompleted) {
      return IcePages.splash.name;
    }

    if (isSplash && !isInitInProgress && isAnimationCompleted) {
      if (_authState is Authenticated) {
        return IcePages.wallet.name;
      }
      if (_authState is UnAuthenticated) {
        /// Navigate to the Intro screen after splash for unauthenticated users
        return IcePages.intro.name;
      }
    }

    if (isAuthInProgress && _authState is Authenticated) {
      return IcePages.wallet.name;
    }

    if (!isAuthInProgress && _authState is UnAuthenticated) {
      return IcePages.intro.name;
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
