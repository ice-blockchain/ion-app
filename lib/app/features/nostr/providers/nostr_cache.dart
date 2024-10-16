// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
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

AlwaysAliveProviderListenable<T?> nostrCache<T>(String key) {
  return nostrCacheProvider.select((state) => state[T]?[key] as T?);
}
