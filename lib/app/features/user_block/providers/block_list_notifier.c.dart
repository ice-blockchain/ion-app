// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/user_block/model/database/block_user_database.c.dart';
import 'package:ion/app/features/user_block/model/entities/blocked_user_entity.c.dart';
import 'package:ion/app/features/user_block/optimistic_ui/block_user_provider.c.dart';
import 'package:ion/app/services/riverpod/provider_cache_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_list_notifier.c.g.dart';

// Cache for blocked status to reduce rebuilds
final _blockStatusCache = ProviderCache<String, bool>(maxAge: const Duration(minutes: 5));

@riverpod
class CurrentUserBlockListNotifier extends _$CurrentUserBlockListNotifier {
  @override
  Future<List<BlockedUserEntity>> build() async {
    final keepAlive = ref.keepAlive();
    onLogout(ref, keepAlive.close);

    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final blockEventDao = ref.watch(blockEventDaoProvider);

    final initialEvents = await blockEventDao.getBlockedUsersEvents(currentUserMasterPubkey);
    final initialEntities = initialEvents.map(BlockedUserEntity.fromEventMessage).toList();
    state = AsyncValue.data(initialEntities);

    final subscription =
        blockEventDao.watchBlockedUsersEvents(currentUserMasterPubkey).listen((blockEvents) {
      final entities = blockEvents.map(BlockedUserEntity.fromEventMessage).toList();
      state = AsyncValue.data(entities);
      
      // Clear the block status cache when block list changes
      _blockStatusCache.clear();
    });
    ref.onDispose(subscription.cancel);

    return initialEntities;
  }
}

@riverpod
class CurrentUserBlockedByListNotifier extends _$CurrentUserBlockedByListNotifier {
  @override
  Future<List<BlockedUserEntity>> build() async {
    keepAliveWhenAuthenticated(ref);
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      return [];
    }

    final blockEventDao = ref.watch(blockEventDaoProvider);

    final initialEvents = await blockEventDao.getBlockedByUsersEvents(currentUserMasterPubkey);
    final initialEntities = initialEvents.map(BlockedUserEntity.fromEventMessage);

    final subscription =
        blockEventDao.watchBlockedByUsersEvents(currentUserMasterPubkey).listen((events) {
      final entities = events.map(BlockedUserEntity.fromEventMessage);
      state = AsyncValue.data(entities.toList());
      
      // Clear the block status cache when blocked by list changes
      _blockStatusCache.clear();
    });

    ref.onDispose(subscription.cancel);

    return initialEntities.toList();
  }
}

@riverpod
class IsBlockedNotifier extends _$IsBlockedNotifier {
  @override
  Future<bool> build(String masterPubkey) async {
    final keepAlive = ref.keepAlive();
    onLogout(ref, keepAlive.close);

    // Check cache first
    final cacheKey = 'isBlocked:$masterPubkey';
    final cachedValue = _blockStatusCache.get(cacheKey);
    if (cachedValue != null) {
      return cachedValue;
    }

    // Get from provider if not cached
    final blockedUser = await ref.watch(blockedUserWatchProvider(masterPubkey).future);
    final isBlocked = blockedUser != null && blockedUser.isBlocked;
    
    // Cache the result
    _blockStatusCache.put(cacheKey, isBlocked);
    
    return isBlocked;
  }
}

@riverpod
class IsBlockedByNotifier extends _$IsBlockedByNotifier {
  @override
  Future<bool> build(String masterPubkey) async {
    final keepAlive = ref.keepAlive();
    onLogout(ref, keepAlive.close);

    // Check cache first
    final cacheKey = 'isBlockedBy:$masterPubkey';
    final cachedValue = _blockStatusCache.get(cacheKey);
    if (cachedValue != null) {
      return cachedValue;
    }

    // Get from provider if not cached
    final blockedByList = await ref.watch(currentUserBlockedByListNotifierProvider.future);
    final isBlockedBy = blockedByList.any((entity) => entity.masterPubkey == masterPubkey);
    
    // Cache the result
    _blockStatusCache.put(cacheKey, isBlockedBy);
    
    return isBlockedBy;
  }
}

@riverpod
class IsBlockedOrBlockedByNotifier extends _$IsBlockedOrBlockedByNotifier {
  @override
  Future<bool> build(String pubkey) async {
    // Check cache first
    final cacheKey = 'isBlockedOrBlockedBy:$pubkey';
    final cachedValue = _blockStatusCache.get(cacheKey);
    if (cachedValue != null) {
      return cachedValue;
    }

    // Get from providers if not cached
    final isBlocked = await ref.watch(isBlockedNotifierProvider(pubkey).future);
    final isBlockedBy = await ref.watch(isBlockedByNotifierProvider(pubkey).future);
    final result = isBlocked || isBlockedBy;
    
    // Cache the result
    _blockStatusCache.put(cacheKey, result);
    
    return result;
  }
}

// Memoized version of isEntityBlockedOrBlockedBy that reduces rebuilds
final _entityBlockStatusCache = ProviderCache<String, bool>(maxAge: const Duration(minutes: 5));

@riverpod
bool isEntityBlockedOrBlockedBy(Ref ref, IonConnectEntity entity) {
  final entityId = entity.id;
  
  // Check cache first
  final cachedValue = _entityBlockStatusCache.get(entityId);
  if (cachedValue != null) {
    return cachedValue;
  }
  
  // Get direct block status
  final masterPubkey = entity.masterPubkey;
  final isUserBlocked = ref.watch(
    blockedUserWatchProvider(masterPubkey).select(
      (value) => value.valueOrNull?.isBlocked ?? false,
    ),
  );
  
  final blockedByList = ref.watch(
    currentUserBlockedByListNotifierProvider.select(
      (value) => value.valueOrNull ?? [],
    ),
  );
  
  final isDirectlyBlocked = isUserBlocked || 
    blockedByList.any((bEntity) => bEntity.masterPubkey == masterPubkey);
  
  if (isDirectlyBlocked) {
    _entityBlockStatusCache.put(entityId, true);
    return true;
  }
  
  // Check quoted content if needed
  var isQuotedContentBlocked = false;
  
  if (entity is ModifiablePostEntity && entity.data.quotedEvent != null) {
    final quotedEntity = ref.read(
      ionConnectCachedEntityProvider(
        eventReference: entity.data.quotedEvent!.eventReference,
      ),
    );
    if (quotedEntity != null) {
      isQuotedContentBlocked = ref.read(isEntityBlockedOrBlockedByProvider(quotedEntity));
    }
  } else if (entity is GenericRepostEntity) {
    final childEntity = ref.read(
      ionConnectSyncEntityProvider(eventReference: entity.data.eventReference),
    );
    if (childEntity != null) {
      isQuotedContentBlocked = ref.read(isEntityBlockedOrBlockedByProvider(childEntity));
    }
  }
  
  // Cache and return the result
  _entityBlockStatusCache.put(entityId, isQuotedContentBlocked);
  return isQuotedContentBlocked;
}
