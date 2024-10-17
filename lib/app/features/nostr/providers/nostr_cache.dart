// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nostr_cache.g.dart';

mixin CacheableEvent {
  String get cacheKey;

  Type get cacheType;
}

@Riverpod(keepAlive: true)
class NostrCache extends _$NostrCache {
  @override
  Map<Type, Map<String, CacheableEvent>> build() {
    return {};
  }

  void cache(CacheableEvent event) {
    state = {
      ...state,
      event.cacheType: {...(state[event.cacheType] ?? {}), event.cacheKey: event},
    };
  }
}

// TODO:
// Move to a generic family provider instead of current `nostrCacheProvider.select(cacheSelector<...>())` function
// when riverpod_generator v3 is released:
// https://pub.dev/packages/riverpod_generator/versions/3.0.0-dev.11/changelog#300-dev7---2023-10-29
T? Function(Map<Type, Map<String, CacheableEvent>>) cacheSelector<T>(String key) {
  return (Map<Type, Map<String, CacheableEvent>> state) => state[T]?[key] as T?;
}
