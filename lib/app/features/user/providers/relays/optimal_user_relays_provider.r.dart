// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/user/providers/relays/relay_selectors.dart';
import 'package:ion/app/features/user/providers/relays/relevant_user_relays_provider.r.dart';
import 'package:ion/app/features/user/providers/relays/user_relays_manager.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'optimal_user_relays_provider.r.g.dart';

enum OptimalRelaysStrategy {
  /// Groups relays by the number of users using them.
  /// Returns the relays that are used by the most users.
  mostUsers,

  /// Groups relays by their latency.
  /// Returns the relays with the best latency.
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

    final userToRelays = await _getUserRelays(masterPubkeys);

    return switch (strategy) {
      OptimalRelaysStrategy.mostUsers => _getSharedRelaysByMostUsers(userToRelays),
      OptimalRelaysStrategy.bestLatency => await _getSharedRelaysByBestLatency(userToRelays),
    };
  }

  Future<Map<String, List<String>>> _getUserRelays(List<String> masterPubkeys) async {
    final userToRelays = <String, List<String>>{};
    final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

    if (currentUserMasterPubkey != null && masterPubkeys.contains(currentUserMasterPubkey)) {
      final currentUserRelays = await ref.read(currentUserRelaysProvider.future);
      if (currentUserRelays == null) {
        throw UserRelaysNotFoundException();
      }
      userToRelays[currentUserMasterPubkey] = currentUserRelays.urls;
    }

    final otherPubkeys =
        masterPubkeys.where((pubkey) => pubkey != currentUserMasterPubkey).toList();
    if (otherPubkeys.isNotEmpty) {
      final userRelaysManager = ref.read(userRelaysManagerProvider.notifier);
      final otherUsersRelaysList = await userRelaysManager.fetch(otherPubkeys);
      for (final userRelay in otherUsersRelaysList) {
        userToRelays[userRelay.masterPubkey] = userRelay.urls;
      }
    }

    return userToRelays;
  }

  Map<String, List<String>> _getSharedRelaysByMostUsers(
    Map<String, List<String>> userToRelays,
  ) {
    return findMostMatchingOptions(userToRelays);
  }

  Future<Map<String, List<String>>> _getSharedRelaysByBestLatency(
    Map<String, List<String>> userToRelays,
  ) async {
    final rankedRelevantRelays = await ref.read(rankedRelevantCurrentUserRelaysUrlsProvider.future);

    final bestLatencyResults =
        findPriorityOptions(userToRelays, optionsPriority: rankedRelevantRelays);

    final handledUsers = bestLatencyResults.values.expand((urls) => urls).toSet();

    final unhandledUserToRelays = {...userToRelays}..removeWhere(
        (key, value) => handledUsers.contains(key),
      );

    // Fallback to the most matching options if we have users with relays
    // that are all not in ranked relevant relays of the current user.
    final mostUsersResults = findMostMatchingOptions(unhandledUserToRelays);

    return {
      ...bestLatencyResults,
      ...mostUsersResults,
    };
  }
}
