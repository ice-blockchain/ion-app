// SPDX-License-Identifier: ice License 1.0

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
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_user_provider.c.g.dart';

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

  return Future.wait(
    blockEventEntities.map((blockEntity) async {
      final isUnblocked = await unblockEventDao.isUnblocked(blockEntity.toEventReference());

      return BlockedUser(
        isBlocked: !isUnblocked,
        masterPubkey: blockEntity.data.blockedMasterPubkeys.single,
      );
    }),
  );
}

@riverpod
OptimisticService<BlockedUser> blockUserService(Ref ref) {
  final manager = ref.watch(blockUserManagerProvider);
  final service = OptimisticService<BlockedUser>(manager: manager);

  return service;
}

@riverpod
Stream<BlockedUser?> blockedUserWatch(Ref ref, String masterPubkey) {
  final service = ref.watch(blockUserServiceProvider)..initialize(loadInitialBlockedUsers(ref));

  return service.watch(masterPubkey);
}

@riverpod
OptimisticOperationManager<BlockedUser> blockUserManager(Ref ref) {
  final keepAlive = ref.keepAlive();
  onLogout(ref, keepAlive.close);

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

    var current = ref.read(blockedUserWatchProvider(masterPubkey)).valueOrNull;

    current ??= BlockedUser(
      isBlocked: false,
      masterPubkey: masterPubkey,
    );

    await service.dispatch(ToggleBlockIntent(), current);
  }
}
