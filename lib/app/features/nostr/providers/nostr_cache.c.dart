// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nostr_cache.c.g.dart';

final _nostrCacheStreamController = StreamController<NostrEntity>.broadcast();

mixin CacheableEntity on NostrEntity {
  String get cacheKey;
}

@Riverpod(keepAlive: true)
class NostrCache extends _$NostrCache {
  @override
  Map<String, CacheableEntity> build() {
    return {};
  }

  void cache(CacheableEntity event) {
    state = {...state, event.cacheKey: event};
    _nostrCacheStreamController.sink.add(event);
  }

  void remove(String key) {
    state = {...state}..remove(key);
  }
}

@Riverpod(keepAlive: true)
Raw<Stream<NostrEntity>> nostrCacheStream(Ref ref) {
  return _nostrCacheStreamController.stream;
}

// TODO:
// Move to a generic family provider instead of current `nostrCacheProvider.select(cacheSelector<...>())` function
// when riverpod_generator v3 is released:
// https://pub.dev/packages/riverpod_generator/versions/3.0.0-dev.11/changelog#300-dev7---2023-10-29
T? Function(Map<String, CacheableEntity>) cacheSelector<T extends NostrEntity>(
  String key,
) {
  return (Map<String, CacheableEntity> state) => state[key] as T?;
}
