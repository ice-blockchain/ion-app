// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.r.dart';
import 'package:ion/app/utils/algorithm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_relays_provider.r.g.dart';

/// Strategy for selecting user relays.
enum UsersRelaysStrategy { mostUsers }

@riverpod
class UsersRelaysProvider extends _$UsersRelaysProvider {
  @override
  FutureOr<void> build() async {}

  /// Fetches relays for the given [masterPubkeys] using the specified [strategy].
  Future<Map<String, List<String>>> fetch({
    required List<String> masterPubkeys,
    UsersRelaysStrategy strategy = UsersRelaysStrategy.mostUsers,
  }) async {
    if (masterPubkeys.isEmpty) return {};

    final userToRelays = <String, List<String>>{};
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);

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
      case UsersRelaysStrategy.mostUsers:
        return findBestOptions(userToRelays);
    }
  }
}
