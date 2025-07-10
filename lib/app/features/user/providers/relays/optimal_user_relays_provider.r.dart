// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/user/providers/relays/user_relays_manager.r.dart';
import 'package:ion/app/utils/algorithm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'optimal_user_relays_provider.r.g.dart';

enum OptimalRelaysStrategy {
  //TODO:add comment to each strategy
  mostUsers,
  bestLatency
}

/// Finds the optimal relays for the given user pubkeys.
///
/// Use it when you need to find relays shared by multiple users.
/// Returns a map where each key is a relay URL
/// and the value is a list of pubkeys available on that relay
///
@riverpod
class OptimalUserRelays extends _$OptimalUserRelays {
  @override
  FutureOr<void> build() async {}

  Future<Map<String, List<String>>> fetch({
    required List<String> masterPubkeys,
    required OptimalRelaysStrategy strategy,
  }) async {
    if (masterPubkeys.isEmpty) return {};

    final userToRelays = <String, List<String>>{};
    final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

    if (currentUserMasterPubkey != null && masterPubkeys.contains(currentUserMasterPubkey)) {
      final currentUserRelays = await ref.read(currentUserRelaysProvider.future);
      if (currentUserRelays == null) {
        throw UserRelaysNotFoundException();
      }
      userToRelays[currentUserMasterPubkey] = currentUserRelays.urls;
    }

    final otherPubkeys = masterPubkeys.where((pk) => pk != currentUserMasterPubkey).toList();
    if (otherPubkeys.isNotEmpty) {
      final userRelaysManager = ref.read(userRelaysManagerProvider.notifier);
      final otherUsersRelaysList = await userRelaysManager.fetch(otherPubkeys);
      for (final userRelay in otherUsersRelaysList) {
        userToRelays[userRelay.masterPubkey] = userRelay.urls;
      }
    }

    switch (strategy) {
      case OptimalRelaysStrategy.mostUsers:
        return findMostMatchingOptions(userToRelays);
      case OptimalRelaysStrategy.bestLatency:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
