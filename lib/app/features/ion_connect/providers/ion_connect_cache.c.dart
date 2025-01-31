// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_cache.c.g.dart';

final _ionConnectCacheStreamController = StreamController<IonConnectEntity>.broadcast();

mixin CacheableEntity on IonConnectEntity {
  String get cacheKey => cacheKeyBuilder(eventReference: toEventReference());

  static String cacheKeyBuilder({required EventReference eventReference}) =>
      eventReference.toString();
}

class CacheEntry {
  CacheEntry({
    required this.entity,
    required this.createdAt,
  });

  final CacheableEntity entity;
  final DateTime createdAt;
}

@Riverpod(keepAlive: true)
class IonConnectCache extends _$IonConnectCache {
  @override
  Map<String, CacheEntry> build() {
    return {};
  }

  void cache(CacheableEntity entity) {
    final entry = CacheEntry(
      entity: entity,
      createdAt: DateTime.now(),
    );
    state = {...state, entity.cacheKey: entry};

    _ionConnectCacheStreamController.sink.add(entity);
  }

  void remove(String key) {
    state = {...state}..remove(key);
  }
}

@Riverpod(keepAlive: true)
Raw<Stream<IonConnectEntity>> ionConnectCacheStream(Ref ref) {
  return _ionConnectCacheStreamController.stream;
}

// TODO:
// Move to a generic family provider instead of current `ionConnectCacheProvider.select(cacheSelector<...>())` function
// when riverpod_generator v3 is released:
// https://pub.dev/packages/riverpod_generator/versions/3.0.0-dev.11/changelog#300-dev7---2023-10-29
T? Function(Map<String, CacheEntry>) cacheSelector<T extends IonConnectEntity>(
  String key, {
  Duration? expirationDuration,
}) {
  return (Map<String, CacheEntry> state) {
    final entry = state[key];

    if (entry == null) return null;

    if (expirationDuration != null &&
        entry.createdAt.isBefore(DateTime.now().subtract(expirationDuration))) {
      return null;
    }
    return entry.entity as T;
  };
}
