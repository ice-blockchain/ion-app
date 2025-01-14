// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_cache.c.g.dart';

final _ionConnectCacheStreamController = StreamController<IonConnectEntity>.broadcast();

mixin CacheableEntity on IonConnectEntity {
  String get cacheKey;
}

@Riverpod(keepAlive: true)
class IonConnectCache extends _$IonConnectCache {
  @override
  Map<String, CacheableEntity> build() {
    return {};
  }

  void cache(CacheableEntity event) {
    state = {...state, event.cacheKey: event};
    _ionConnectCacheStreamController.sink.add(event);
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
T? Function(Map<String, CacheableEntity>) cacheSelector<T extends IonConnectEntity>(
  String key,
) {
  return (Map<String, CacheableEntity> state) => state[key] as T?;
}
