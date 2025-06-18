// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_db_cache_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/riverpod/provider_cache_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_entity_provider.c.g.dart';

// Cache for entity results to avoid excessive rebuilds
final _entityCache = ProviderCache<String, IonConnectEntity?>();

@riverpod
IonConnectEntity? ionConnectCachedEntity(
  Ref ref, {
  required EventReference eventReference,
}) {
  final cacheKey = CacheableEntity.cacheKeyBuilder(eventReference: eventReference);
  
  // Use select to only watch the specific entity in the cache
  return ref.watch(
    ionConnectCacheProvider.select(
      cacheSelector(cacheKey),
    ),
  );
}

@riverpod
Future<IonConnectEntity?> ionConnectNetworkEntity(
  Ref ref, {
  required EventReference eventReference,
  String? search,
  ActionSource? actionSource,
}) async {
  final aSource = actionSource ?? ActionSourceUser(eventReference.pubkey);
  if (eventReference is ImmutableEventReference) {
    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          ids: [eventReference.eventId],
          search: search,
          limit: 1,
        ),
      );
    return ref.read(ionConnectNotifierProvider.notifier).requestEntity(
          requestMessage,
          actionSource: aSource,
          entityEventReference: eventReference,
        );
  } else if (eventReference is ReplaceableEventReference) {
    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: [eventReference.kind],
          authors: [eventReference.pubkey],
          tags: {
            if (eventReference.dTag.isNotEmpty) '#d': [eventReference.dTag],
          },
          search: search,
          limit: 1,
        ),
      );
    return ref.read(ionConnectNotifierProvider.notifier).requestEntity(
          requestMessage,
          actionSource: aSource,
          entityEventReference: eventReference,
        );
  } else {
    throw UnsupportedEventReference(eventReference);
  }
}

@riverpod
Future<IonConnectEntity?> ionConnectDbEntity(
  Ref ref, {
  required EventReference eventReference,
}) async {
  return ref.read(ionConnectDbCacheProvider.notifier).get(eventReference);
}

@riverpod
Future<IonConnectEntity?> ionConnectEntity(
  Ref ref, {
  required EventReference eventReference,
  bool network = true,
  bool cache = true,
  String? search,
}) async {
  final cacheKey = eventReference.toString();
  
  // Check if we have a cached result
  final cachedEntity = _entityCache.get(cacheKey);
  if (cachedEntity != null) {
    return cachedEntity;
  }
  
  // Only watch the current identity key name, not the entire auth state
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    throw const CurrentUserNotFoundException();
  }
  
  if (cache) {
    // Use read instead of watch to avoid unnecessary rebuilds
    final entity = ref.read(ionConnectCachedEntityProvider(eventReference: eventReference));
    if (entity != null) {
      // Cache the result
      _entityCache.put(cacheKey, entity);
      return entity;
    }
  }
  
  if (network) {
    final entity = await ref.read(
      ionConnectNetworkEntityProvider(eventReference: eventReference, search: search).future,
    );
    
    // Cache the result
    if (entity != null) {
      _entityCache.put(cacheKey, entity);
    }
    
    return entity;
  }
  
  return null;
}

@riverpod
IonConnectEntity? ionConnectSyncEntity(
  Ref ref, {
  required EventReference eventReference,
  bool network = true,
  bool cache = true,
  bool db = false,
  String? search,
}) {
  final cacheKey = eventReference.toString();
  
  // Check if we have a cached result
  final cachedEntity = _entityCache.get(cacheKey);
  if (cachedEntity != null) {
    return cachedEntity;
  }
  
  // Only watch the current identity key name, not the entire auth state
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    throw const CurrentUserNotFoundException();
  }
  
  if (cache) {
    // Use select to only watch the specific entity in the cache
    final entity = ref.watch(ionConnectCachedEntityProvider(eventReference: eventReference));
    if (entity != null) {
      // Cache the result
      _entityCache.put(cacheKey, entity);
      return entity;
    }
  }

  if (db) {
    final entityState = ref.watch(ionConnectDbEntityProvider(eventReference: eventReference));
    if (entityState.isLoading) {
      return null;
    }
    final entity = entityState.valueOrNull;
    if (entity != null) {
      // Cache the result
      _entityCache.put(cacheKey, entity);
      return entity;
    }
  }
  
  if (network) {
    final entity = ref.watch(
      ionConnectNetworkEntityProvider(eventReference: eventReference, search: search)
    ).valueOrNull;
    
    // Cache the result
    if (entity != null) {
      _entityCache.put(cacheKey, entity);
    }
    
    return entity;
  }
  
  return null;
}
