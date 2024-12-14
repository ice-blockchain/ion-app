import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/router/app_routes.c.dart';

typedef RouteAwareCallback = void Function();

class RouteAwareCallbacks {
  const RouteAwareCallbacks({
    this.onPush,
    this.onPop,
    this.onPopNext,
    this.onPushNext,
  });
  final RouteAwareCallback? onPush;
  final RouteAwareCallback? onPop;
  final RouteAwareCallback? onPopNext;
  final RouteAwareCallback? onPushNext;
}

class _RouteAwareHook extends RouteAware {
  _RouteAwareHook(this.routeName, this.callbacks);
  final String routeName;
  final RouteAwareCallbacks callbacks;

  @override
  void didPush() {
    callbacks.onPush?.call();
    log('[$routeName] didPush - route $routeName is active', name: 'RouteAware');
  }

  @override
  void didPop() {
    callbacks.onPop?.call();
    log('[$routeName] didPop - route $routeName is closed', name: 'RouteAware');
  }

  @override
  void didPopNext() {
    callbacks.onPopNext?.call();
    log('[$routeName] didPopNext - returned to $routeName', name: 'RouteAware');
  }

  @override
  void didPushNext() {
    callbacks.onPushNext?.call();
    log(
      '[$routeName] didPushNext - another screen appeared on top of $routeName',
      name: 'RouteAware',
    );
  }
}

/// A Flutter Hook that implements route awareness functionality.
///
/// This hook allows tracking navigation events and executing callbacks when:
/// - A route is pushed onto the navigation stack
/// - A route is popped from the navigation stack
/// - Another route is pushed on top of the current route
/// - User returns to this route after popping the top route
void useRouteAware({RouteAwareCallbacks? callbacks}) {
  final context = useContext();
  final routeAwareRef = useRef<_RouteAwareHook?>(null);
  final currentRoute = ModalRoute.of(context);
  final goRouterState = GoRouterState.of(context);

  final String currentRouteName = useMemoized(
    () {
      final location = goRouterState.matchedLocation;
      return goRouterState.name ?? goRouterState.fullPath ?? location;
    },
    [goRouterState.matchedLocation],
  );

  final isRouteActive = currentRoute?.isCurrent ?? false;
  final wasRouteActive = usePrevious(isRouteActive);

  useEffect(
    () {
      if (currentRoute == null) return null;

      if ((wasRouteActive ?? false) && !isRouteActive) {
        callbacks?.onPushNext?.call();
      } else if (wasRouteActive == false && isRouteActive) {
        callbacks?.onPopNext?.call();
      }
      return null;
    },
    [isRouteActive, wasRouteActive, currentRouteName],
  );

  useEffect(
    () {
      if (currentRoute == null) return null;

      routeAwareRef.value = _RouteAwareHook(
        currentRouteName,
        callbacks ?? const RouteAwareCallbacks(),
      );

      routeObserver.subscribe(routeAwareRef.value!, currentRoute);

      return () {
        if (routeAwareRef.value != null) {
          routeObserver.unsubscribe(routeAwareRef.value!);
          routeAwareRef.value = null;
        }
      };
    },
    [currentRoute, currentRouteName],
  );
}
