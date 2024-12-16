// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:ion/app/router/data/models/route_event.c.dart';

enum RouteChangeType {
  none,
  push,
  pop,
  pushNext,
}

abstract class RouteEventHandler {
  void handleRouteEvent(RouteEvent event) {
    final type = determineChangeType(event);
    handleRouteChange(event, type);
  }

  void handleRouteChange(RouteEvent event, RouteChangeType type);

  /// It is assumed that all root routes are equivalent,
  /// and with the same depth but different segments — this is pushNext.
  RouteChangeType determineChangeType(RouteEvent event) {
    final oldSegments = event.oldSegments;
    final newSegments = event.newSegments;

    if (newSegments.length > oldSegments.length) {
      return RouteChangeType.push;
    } else if (newSegments.length < oldSegments.length) {
      return RouteChangeType.pop;
    } else if (newSegments.length == oldSegments.length && !listEquals(oldSegments, newSegments)) {
      // Horizontal transition between routes of the same level
      // without order — consider it pushNext.
      return RouteChangeType.pushNext;
    }

    return RouteChangeType.none;
  }
}
