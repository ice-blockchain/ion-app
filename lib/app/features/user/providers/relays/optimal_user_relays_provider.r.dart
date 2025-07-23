// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/user/model/user_relays.f.dart';
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
class OptimalUserRelaysService {
  OptimalUserRelaysService({
    required String? currentUserMasterPubkey,
    required Future<UserRelaysEntity?> Function() getCurrentUserRelays,
    required Future<List<UserRelaysEntity>> Function(List<String> pubkeys) getGenericUserRelays,
    required Future<List<String>> Function() getCurrentUserRankedRelevantRelays,
  })  : _currentUserMasterPubkey = currentUserMasterPubkey,
        _getCurrentUserRelays = getCurrentUserRelays,
        _getGenericUserRelays = getGenericUserRelays,
        _getCurrentUserRankedRelevantRelays = getCurrentUserRankedRelevantRelays;

  final String? _currentUserMasterPubkey;

  final Future<UserRelaysEntity?> Function() _getCurrentUserRelays;

  final Future<List<UserRelaysEntity>> Function(List<String> pubkeys) _getGenericUserRelays;

  final Future<List<String>> Function() _getCurrentUserRankedRelevantRelays;

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

  //TODO[REFACTOR] exclude separate _getCurrentUserRelays processing from here, rename _getGenericUserRelays to _getReachableUserRelays
  Future<Map<String, List<String>>> _getUserRelays(List<String> masterPubkeys) async {
    final userToRelays = <String, List<String>>{};

    if (_currentUserMasterPubkey != null && masterPubkeys.contains(_currentUserMasterPubkey)) {
      final currentUserRelays = await _getCurrentUserRelays();
      if (currentUserRelays == null || currentUserRelays.urls.isEmpty) {
        throw UserRelaysNotFoundException();
      }
      userToRelays[_currentUserMasterPubkey] = currentUserRelays.urls;
    }

    final otherPubkeys =
        masterPubkeys.where((pubkey) => pubkey != _currentUserMasterPubkey).toList();
    if (otherPubkeys.isNotEmpty) {
      final otherUsersRelaysList = await _getGenericUserRelays(otherPubkeys);
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
    final rankedRelevantRelays = await _getCurrentUserRankedRelevantRelays();

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

@riverpod
OptimalUserRelaysService optimalUserRelaysService(Ref ref) {
  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
  Future<UserRelaysEntity?> getCurrentUserRelays() => ref.read(currentUserRelaysProvider.future);
  Future<List<UserRelaysEntity>> getGenericUserRelays(List<String> pubkeys) =>
      ref.read(userRelaysManagerProvider.notifier).fetch(pubkeys);
  Future<List<String>> getCurrentUserRankedRelevantRelays() =>
      ref.read(rankedRelevantCurrentUserRelaysUrlsProvider.future);
  return OptimalUserRelaysService(
    currentUserMasterPubkey: currentUserMasterPubkey,
    getCurrentUserRelays: getCurrentUserRelays,
    getGenericUserRelays: getGenericUserRelays,
    getCurrentUserRankedRelevantRelays: getCurrentUserRankedRelevantRelays,
  );
}
