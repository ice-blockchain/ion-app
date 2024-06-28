import 'package:flutter/material.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/core/providers/init_provider.dart';
import 'package:ice/app/features/core/providers/splash_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_app_router_listenable.g.dart';

@Riverpod(keepAlive: true)
class MyAppRouterListenable extends _$MyAppRouterListenable
    implements Listenable {
  VoidCallback? _routerListener;

  @override
  Future<void> build() async {
    ref
      ..listenSelf((_, __) {
        if (state.isLoading) {
          return;
        }
        _routerListener?.call();
      })
      ..listen(authProvider, (previous, next) => _routerListener?.call())
      ..listen(initAppProvider, (previous, next) => _routerListener?.call())
      ..listen(
        splashProvider,
        (previous, next) => _routerListener?.call(),
      );
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
