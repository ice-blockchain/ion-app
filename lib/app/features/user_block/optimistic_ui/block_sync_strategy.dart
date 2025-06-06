// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/optimistic_ui/core/optimistic_sync_strategy.dart';
import 'package:ion/app/features/user_block/optimistic_ui/model/blocked_user.c.dart';

/// Sync strategy for toggling likes using IonConnectNotifier.
class BlockSyncStrategy implements SyncStrategy<BlockedUser> {
  BlockSyncStrategy({
    required this.sendBlockEvent,
    required this.deleteBlockEvent,
  });

  final Future<void> Function(String) sendBlockEvent;
  final Future<void> Function(String) deleteBlockEvent;

  @override
  Future<BlockedUser> send(BlockedUser previous, BlockedUser optimistic) async {
    final toggledToBlock = optimistic.isBlocked && !previous.isBlocked;
    final toggledToUnblock = !optimistic.isBlocked && previous.isBlocked;

    if (toggledToBlock) {
      await sendBlockEvent(optimistic.masterPubkey);
    } else if (toggledToUnblock) {
      await deleteBlockEvent(optimistic.masterPubkey);
    }
    return optimistic;
  }
}
