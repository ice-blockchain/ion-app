// SPDX-License-Identifier: ice License 1.0

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/router/data/models/route_event.c.dart';
import 'package:ion/app/router/handlers/handlers.dart';
import 'package:ion/app/router/providers/go_router_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'route_events_provider.c.g.dart';

@riverpod
List<RouteEventHandler> routeEventHandlers(Ref ref) {
  final storyViewerHandler = ref.watch(storyEventHandlerProvider);

  return [
    storyViewerHandler,
  ];
}

@Riverpod(keepAlive: true)
void routeEventsDispatcher(Ref ref) {
  final handlers = ref.watch(routeEventHandlersProvider);

  ref.listen(routeEventsProvider, (previous, next) {
    if (next == null) return;

    for (final handler in handlers) {
      handler.handleRouteEvent(next);
    }
  });
}

@Riverpod(keepAlive: true)
class RouteEvents extends _$RouteEvents {
  @override
  RouteEvent? build() {
    final goRouter = ref.watch(goRouterProvider);

    var oldPath = '';

    void listener() {
      final configuration = goRouter.routerDelegate.currentConfiguration;
      final finalLocation = _extractFinalMatchedLocation(configuration.matches);
      final newPath = finalLocation;

      final routeEvent = RouteEvent.fromPaths(oldPath, newPath);
      state = routeEvent;

      Logger.log('Route changed: $oldPath -> $newPath', name: 'RouteEventsNotifier');

      oldPath = newPath;
    }

    goRouter.routerDelegate.addListener(listener);

    ref.onDispose(() {
      goRouter.routerDelegate.removeListener(listener);
    });

    return null;
  }

  String _extractFinalMatchedLocation(List<RouteMatchBase> matches) {
    if (matches.isEmpty) return '';

    final lastMatch = matches.last;

    if (lastMatch is ShellRouteMatch) {
      return _extractFinalMatchedLocation(lastMatch.matches);
    }

    return lastMatch.matchedLocation;
  }
}
