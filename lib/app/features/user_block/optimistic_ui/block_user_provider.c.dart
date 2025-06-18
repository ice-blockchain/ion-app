// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';

import 'package:ion/app/features/optimistic_ui/core/operation_manager.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_service.dart';
import 'package:ion/app/features/user_block/model/database/block_user_database.c.dart';
import 'package:ion/app/features/user_block/model/entities/blocked_user_entity.c.dart';
import 'package:ion/app/features/user_block/optimistic_ui/block_sync_strategy_provider.c.dart';
import 'package:ion/app/features/user_block/optimistic_ui/model/blocked_user.c.dart';
import 'package:ion/app/features/user_block/optimistic_ui/toggle_block_intent.dart';
import 'package:ion/app/services/riverpod/provider_cache_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_user_provider.c.g.dart';

// Stream cache for blocked users to avoid excessive rebuilds
final _blockedUsersStreamCache = StreamCache<String, BlockedUser?>();

// Memory cache for blocked users to reduce database reads
final _blockedUserMemoryCache = ProviderCache<String, BlockedUser?>(
  maxAge: const Duration(minutes: 10),
);

// Batch update manager to reduce frequent updates
final _batchUpdateManager = BatchUpdateManager<String, BlockedUser?>(
  batchInterval: const Duration(milliseconds: 500),
  onBatchComplete: (Map<String, BlockedUser?> updates) {
    for (final entry in updates.entries) {
      _blockedUsersStreamCache.addToStream(entry.key, entry.value);
    }
  },
);

@riverpod
Future<List<BlockedUser>> loadInitialBlockedUsers(Ref ref) async {
  final currentMasterPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentMasterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final blockEventDao = ref.watch(blockEventDaoProvider);
  final blockEvents = await blockEventDao.getBlockedUsersEvents(currentMasterPubkey);
  final blockEventEntities = blockEvents.map(BlockedUserEntity.fromEventMessage).toList();

  final unblockEventDao = ref.watch(unblockEventDaoProvider);

  final blockedUsers = await Future.wait(
    blockEventEntities.map((blockEntity) async {
      final isUnblocked = await unblockEventDao.isUnblocked(blockEntity.toEventReference());
      final blockedUser = BlockedUser(
        isBlocked: !isUnblocked,
        masterPubkey: blockEntity.data.blockedMasterPubkeys.single,
      );
      
      // Cache the result
      _blockedUserMemoryCache.put(blockedUser.masterPubkey, blockedUser);
      
      return blockedUser;
    }),
  );
  
  return blockedUsers;
}

@riverpod
OptimisticService<BlockedUser> blockUserService(Ref ref) {
  final manager = ref.watch(blockUserManagerProvider);
  final service = OptimisticService<BlockedUser>(manager: manager);

  return service;
}

@riverpod
Stream<BlockedUser?> blockedUserWatch(Ref ref, String masterPubkey) {
  // Check memory cache first
  final cachedValue = _blockedUserMemoryCache.get(masterPubkey);
  
  // Get or create a stream for this pubkey
  final streamController = _blockedUsersStreamCache.getOrCreateStream(masterPubkey);
  
  // If we have a cached value, emit it immediately
  if (cachedValue != null) {
    _blockedUsersStreamCache.addToStream(masterPubkey, cachedValue);
  }
  
  // Initialize the service only once
  final service = ref.read(blockUserServiceProvider);
  
  // Use onDispose to clean up the stream controller when no longer needed
  ref.onDispose(() {
    if (!_blockedUsersStreamCache.hasListeners(masterPubkey)) {
      _blockedUsersStreamCache.closeAndRemoveStream(masterPubkey);
    }
  });
  
  // If the controller doesn't have a listener yet, initialize it
  if (!_blockedUsersStreamCache.hasListeners(masterPubkey)) {
    // Initialize with cached data if available
    if (cachedValue == null) {
      service.initialize(loadInitialBlockedUsers(ref));
    }
    
    // Subscribe to the service's stream for this pubkey using batch updates
    service.watch(masterPubkey).listen((blockedUser) {
      // Update the memory cache
      _blockedUserMemoryCache.put(masterPubkey, blockedUser);
      
      // Add to batch update manager
      _batchUpdateManager.queueUpdate(masterPubkey, blockedUser);
    });
  }
  
  return streamController.stream;
}

@riverpod
OptimisticOperationManager<BlockedUser> blockUserManager(Ref ref) {
  keepAliveWhenAuthenticated(ref);

  final strategy = ref.watch(blockSyncStrategyProvider);

  final manager = OptimisticOperationManager<BlockedUser>(
    syncCallback: strategy.send,
    onError: (_, __) async => true,
  );

  ref.onDispose(manager.dispose);

  return manager;
}

@riverpod
class ToggleBlockNotifier extends _$ToggleBlockNotifier {
  @override
  void build() {}

  Future<void> toggle(String masterPubkey) async {
    final service = ref.read(blockUserServiceProvider);

    // Try to get from cache first
    final current = _blockedUserMemoryCache.get(masterPubkey) ?? 
                   ref.read(blockedUserWatchProvider(masterPubkey)).valueOrNull ??
                   BlockedUser(
                     isBlocked: false,
                     masterPubkey: masterPubkey,
                   );

    // Update cache immediately for optimistic UI
    final updatedUser = BlockedUser(
      isBlocked: !current.isBlocked,
      masterPubkey: masterPubkey,
    );
    
    _blockedUserMemoryCache.put(masterPubkey, updatedUser);
    _blockedUsersStreamCache.addToStream(masterPubkey, updatedUser);
    
    // Dispatch the actual intent
    await service.dispatch(ToggleBlockIntent(), current);
  }
}
