// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/optimistic_ui/core/optimistic_intent.dart';
import 'package:ion/app/features/user_block/data/models/optimistic_ui/blocked_user.c.dart';

/// Intent to toggle block state for a user.
final class ToggleBlockIntent implements OptimisticIntent<BlockedUser> {
  @override
  BlockedUser optimistic(BlockedUser current, [String? dtag]) =>
      current.copyWith(isBlocked: !current.isBlocked);

  @override
  Future<BlockedUser> sync(BlockedUser prev, BlockedUser next) =>
      throw UnimplementedError('Sync is handled by strategy');
}
