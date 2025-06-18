// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_db_cache_notifier.c.dart';
import 'package:ion/app/services/riverpod/container.dart';
import 'package:ion/app/services/riverpod/provider_cache_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_cache.c.g.dart';

// Use a broadcast controller for more efficient streaming
final _ionConnectCacheStreamController = StreamController<IonConnectEntity>.broadcast();

// Batch update manager for the cache
final _batchUpdateManager = BatchUpdateManager<String, CacheableEntity>(
  batchInterval: const Duration(milliseconds: 100),
  onBatchComplete: _processBatchUpdates,
);

void _processBatchUpdates(Map<String, CacheableEntity> updates) {
  if (updates.isEmpty) return;
  
  // Get the current state from the global container
  final notifier = riverpodContainer.read(ionConnectCacheProvider.notifier);
  final currentState = riverpodContainer.read(ionConnectCacheProvider);
  
  // Create a new state with all pending updates
  final newState = Map<String, CacheEntry>.from(currentState);
  
  for (final entity in updates.values) {
    newState[entity.cacheKey] = CacheEntry(
      entity: entity,
      createdAt: DateTime.now(),
    );
  }
  
  // Update state once for all pending updates
  notifier.state = newState;
}

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
    onLogout(ref, () {
      state = {};
      _batchUpdateManager.dispose();
    });
    return {};
  }

  void cache(CacheableEntity entity) {
    // Add to batch update manager
    _batchUpdateManager.queueUpdate(entity.cacheKey, entity);
    
    // Always emit to stream for immediate listeners
    _ionConnectCacheStreamController.sink.add(entity);

    // Save to DB cache if needed
    if (entity is DbCacheableEntity) {
      ref.read(ionConnectDbCacheProvider.notifier).save(entity as DbCacheableEntity);
    }
  }

  void remove(String key) {
    // Remove from pending updates
    _batchUpdateManager.removeUpdate(key);
    
    // Only update state if the key exists
    if (state.containsKey(key)) {
      state = {...state}..remove(key);
    }
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
