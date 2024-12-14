import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final routeObserver = RouteObserver<PageRoute<dynamic>>();

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

void useRouteAware({RouteAwareCallbacks? callbacks}) {
  final context = useContext();
  final routeAwareRef = useRef<_RouteAwareHook?>(null);

  useEffect(
    () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final route = ModalRoute.of(context);
        log('route: $route', name: 'RouteAware');
        log('route.runtimeType: ${route.runtimeType}', name: 'RouteAware');
        if (route is PageRoute) {
          final routeName = route.settings.name ?? 'unknown_route';
          routeAwareRef.value = _RouteAwareHook(
            routeName,
            callbacks ?? const RouteAwareCallbacks(),
          );
          routeObserver.subscribe(routeAwareRef.value!, route);
        }
      });

      return () {
        if (routeAwareRef.value != null) {
          routeObserver.unsubscribe(routeAwareRef.value!);
        }
      };
    },
    const [],
  );
}
