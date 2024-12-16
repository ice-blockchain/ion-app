// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_event.c.freezed.dart';

@freezed
class RouteEvent with _$RouteEvent {
  factory RouteEvent({
    required String oldPath,
    required String newPath,
    required List<String> oldSegments,
    required List<String> newSegments,
  }) = _RouteEvent;

  RouteEvent._();

  factory RouteEvent.fromPaths(String oldPath, String newPath) {
    final oldSeg = oldPath.isEmpty ? <String>[] : oldPath.split('/');
    final newSeg = newPath.isEmpty ? <String>[] : newPath.split('/');

    return RouteEvent(
      oldPath: oldPath,
      newPath: newPath,
      oldSegments: oldSeg,
      newSegments: newSeg,
    );
  }
}
