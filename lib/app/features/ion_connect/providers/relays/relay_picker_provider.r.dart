// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart' hide requestEvents;
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/disliked_relay_urls_collection.f.dart';
import 'package:ion/app/features/ion_connect/providers/relays/active_relays_provider.r.dart';
import 'package:ion/app/features/ion_connect/providers/relays/relay_provider.r.dart';
import 'package:ion/app/features/user/model/user_relays.f.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.r.dart';
import 'package:ion/app/features/user/providers/relays/ranked_user_relays_provider.r.dart';
import 'package:ion/app/features/user/providers/relays/relevant_user_relays_provider.r.dart';
import 'package:ion/app/features/user/providers/relays/user_relays_manager.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_picker_provider.r.g.dart';

enum ActionType { read, write }

@riverpod
class RelayPicker extends _$RelayPicker {
  @override
  FutureOr<void> build() {}

  Future<IonConnectRelay> getActionSourceRelay(
    ActionSource actionSource, {
    required ActionType actionType,
    DislikedRelayUrlsCollection dislikedUrls = const DislikedRelayUrlsCollection({}),
  }) async {
    return switch (actionType) {
      ActionType.read => _getReadActionSourceRelay(actionSource, dislikedUrls: dislikedUrls),
      ActionType.write => _getWriteActionSourceRelay(actionSource, dislikedUrls: dislikedUrls),
    };
  }

  Future<IonConnectRelay> _getWriteActionSourceRelay(
    ActionSource actionSource, {
    DislikedRelayUrlsCollection dislikedUrls = const DislikedRelayUrlsCollection({}),
  }) async {
    final reachableRelays = switch (actionSource) {
      ActionSourceCurrentUser() => await _getCurrentUserReachableRelays().then(_filterWriteRelays),
      ActionSourceUser() =>
        await _getUserReachableRelays(actionSource.pubkey).then(_filterWriteRelays),
      ActionSourceRelayUrl() => [UserRelay(url: actionSource.url)],
      _ => throw UnsupportedError(
          'ActionSource $actionSource is not supported for write action type.',
        )
    };

    Logger.log(
      '[RELAY] Selecting a write relay for action source: $actionSource, reachable relay list: $reachableRelays, $dislikedUrls',
    );

    if (reachableRelays.isEmpty) {
      Logger.warning(
        '[RELAY] No reachable write relay found for action source: $actionSource. Fallback to read action source relay.',
      );
      return _getReadActionSourceRelay(actionSource, dislikedUrls: dislikedUrls);
    }

    final reachableRelayUrls = reachableRelays.map((relay) => relay.url).toList();
    final filteredWriteRelayUrls = _filterOutDislikedRelayUrls(reachableRelayUrls, dislikedUrls);
    final chosenRelayUrl =
        _getFirstActiveRelayUrl(filteredWriteRelayUrls) ?? filteredWriteRelayUrls.random!;
    return ref.read(relayProvider(chosenRelayUrl, anonymous: actionSource.anonymous).future);
  }

  Future<IonConnectRelay> _getReadActionSourceRelay(
    ActionSource actionSource, {
    DislikedRelayUrlsCollection dislikedUrls = const DislikedRelayUrlsCollection({}),
  }) async {
    Logger.log('[RELAY] Selecting a read relay for action source: $actionSource, $dislikedUrls');

    switch (actionSource) {
      case ActionSourceCurrentUser():
        final currentUserRankedRelays =
            await _getCurrentUserRankedRelays().then((userRelays) => userRelays.data.list);
        final currentUserRankedRelayUrls =
            currentUserRankedRelays.map((relay) => relay.url).toList();
        final filteredRankedRelays =
            _filterOutDislikedRelayUrls(currentUserRankedRelayUrls, dislikedUrls);
        final chosenRelayUrl =
            _getFirstActiveRelayUrl(filteredRankedRelays) ?? filteredRankedRelays.first;
        return ref.read(relayProvider(chosenRelayUrl, anonymous: actionSource.anonymous).future);

      case ActionSourceUser():
        if (ref.read(isCurrentUserSelectorProvider(actionSource.pubkey))) {
          return _getReadActionSourceRelay(
            ActionSource.currentUser(anonymous: actionSource.anonymous),
            dislikedUrls: dislikedUrls,
          );
        }

        final reachableRelays = await _getUserReachableRelays(actionSource.pubkey)
            .then((userRelays) => userRelays.data.list);
        final reachableRelayUrls = reachableRelays.map((relay) => relay.url).toList();
        final filteredReachableRelays =
            _filterOutDislikedRelayUrls(reachableRelayUrls, dislikedUrls);
        final chosenRelayUrl = _getFirstActiveRelayUrl(filteredReachableRelays) ??
            await _selectRelayUrlForOtherUser(reachableRelayUrls);
        return ref.read(relayProvider(chosenRelayUrl, anonymous: actionSource.anonymous).future);

      case ActionSourceIndexers():
        final indexerUrls = await ref.read(currentUserIndexersProvider.future);
        if (indexerUrls == null) {
          throw UserIndexersNotFoundException();
        }

        final filteredIndexerUrls = _filterOutDislikedRelayUrls(indexerUrls, dislikedUrls);
        final chosenIndexerUrl =
            _getFirstActiveRelayUrl(filteredIndexerUrls) ?? filteredIndexerUrls.random!;
        return ref.read(relayProvider(chosenIndexerUrl, anonymous: actionSource.anonymous).future);

      case ActionSourceRelayUrl():
        return ref.read(relayProvider(actionSource.url, anonymous: actionSource.anonymous).future);
    }
  }

  Future<UserRelaysEntity> _getCurrentUserRankedRelays() async {
    final relays = await ref.read(rankedCurrentUserRelaysProvider.future);
    if (relays == null || relays.urls.isEmpty) {
      throw UserRelaysNotFoundException();
    }
    return relays;
  }

  Future<UserRelaysEntity> _getCurrentUserReachableRelays() async {
    final pubkey = ref.read(currentPubkeySelectorProvider);
    if (pubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }
    return _getUserReachableRelays(pubkey);
  }

  Future<UserRelaysEntity> _getUserReachableRelays(String pubkey) async {
    final relays = await ref.read(userRelaysManagerProvider.notifier).fetch([pubkey]);
    if (relays.isEmpty) {
      throw UserRelaysNotFoundException(pubkey);
    }
    return relays.first;
  }

  /// Filters provided user relay urls by excluding those that are disliked.
  ///
  /// This is a mechanism for retry on another relay if something happened on a chosen one.
  /// For example, if an error happened during read / write operation, on retry, we should try another relay.
  ///
  /// throws [AllRelaysAreDisliked] if no relays are left after filtering.
  List<String> _filterOutDislikedRelayUrls(
    List<String> relayUrls,
    DislikedRelayUrlsCollection dislikedRelaysUrls,
  ) {
    final filteredRelays = relayUrls.toSet().difference(dislikedRelaysUrls.urls).toList();
    if (filteredRelays.isEmpty) {
      Logger.warning('[RELAY] No valid relays found after filtering disliked relays');
      throw AllRelaysAreDisliked();
    }
    return filteredRelays;
  }

  /// Returns the first found active relay url for the given relay url list.
  ///
  /// This is a mechanism to reuse already established connections.
  /// Active relay is a relay that is currently connected and available for use.
  String? _getFirstActiveRelayUrl(List<String> userRelayUrls) {
    final activeRelaysSet = ref.read(activeRelaysProvider);
    if (activeRelaysSet.isEmpty) return null;

    return userRelayUrls.firstWhereOrNull(activeRelaysSet.contains);
  }

  /// Selects a relay url that might be used to fetch other user's content
  /// based on the current user's ranked relevant relays.
  Future<String> _selectRelayUrlForOtherUser(List<String> userRelayUrls) async {
    if (userRelayUrls.length == 1) return userRelayUrls.first;

    final rankedRelevantCurrentUserRelaysUrls =
        await ref.read(rankedRelevantCurrentUserRelaysUrlsProvider.future);

    final optimalUserRelayUrl =
        rankedRelevantCurrentUserRelaysUrls.firstWhereOrNull(userRelayUrls.contains);

    if (optimalUserRelayUrl != null) {
      return optimalUserRelayUrl;
    }

    final randomUserRelayUrl = userRelayUrls.random;
    if (randomUserRelayUrl == null) {
      throw FailedToPickUserRelay();
    }

    return randomUserRelayUrl;
  }

  List<UserRelay> _filterWriteRelays(UserRelaysEntity relayEntity) {
    return relayEntity.data.list.where((relay) => relay.write).toList();
  }
}
