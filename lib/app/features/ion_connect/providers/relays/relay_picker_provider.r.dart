// SPDX-License-Identifier: ice License 1.0

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
    final relays = switch (actionSource) {
      ActionSourceCurrentUser() => await _getCurrentUserRawRelays().then(_filterWriteRelays),
      ActionSourceUser() => await _getUserRawRelays(actionSource.pubkey).then(_filterWriteRelays),
      ActionSourceRelayUrl() => [UserRelay(url: actionSource.url)],
      _ => throw UnsupportedError(
          'ActionSource $actionSource is not supported for write action type.',
        )
    };

    final randomValidWriteRelay = _userRelaysAvoidingDislikedUrls(relays, dislikedUrls).random;

    if (randomValidWriteRelay == null) {
      throw FailedToPickUserRelay();
    }

    return ref.read(
      relayProvider(randomValidWriteRelay.url, anonymous: actionSource.anonymous).future,
    );
  }

  Future<IonConnectRelay> _getReadActionSourceRelay(
    ActionSource actionSource, {
    DislikedRelayUrlsCollection dislikedUrls = const DislikedRelayUrlsCollection({}),
  }) async {
    switch (actionSource) {
      case ActionSourceCurrentUser():
        final pubkey = ref.read(currentPubkeySelectorProvider);
        if (pubkey == null) {
          throw UserMasterPubkeyNotFoundException();
        }

        final userRelays =
            await _getCurrentUserRankedRelays().then((userRelays) => userRelays.data.list);
        final relays = _userRelaysAvoidingDislikedUrls(userRelays, dislikedUrls)
            .map((relay) => relay.url)
            .toList();

        final lastUsedRelays = await _getLastUsedRelay(
          relays,
          dislikedUrls,
          actionSource.anonymous,
        );
        if (lastUsedRelays != null) return lastUsedRelays;

        return ref.read(relayProvider(relays.first, anonymous: actionSource.anonymous).future);

      case ActionSourceUser():
        if (ref.read(isCurrentUserSelectorProvider(actionSource.pubkey))) {
          return getActionSourceRelay(
            ActionSource.currentUser(anonymous: actionSource.anonymous),
            actionType: ActionType.read,
            dislikedUrls: dislikedUrls,
          );
        }

        final userRelays =
            await _getUserRawRelays(actionSource.pubkey).then((userRelays) => userRelays.data.list);
        final relays = _userRelaysAvoidingDislikedUrls(userRelays, dislikedUrls)
            .map((relay) => relay.url)
            .toList();

        final lastUsedRelays = await _getLastUsedRelay(
          relays,
          dislikedUrls,
          actionSource.anonymous,
        );

        if (lastUsedRelays != null) return lastUsedRelays;

        return _selectRelayForOtherUser(relays, actionSource.anonymous);

      case ActionSourceIndexers():
        final indexers = await ref.read(currentUserIndexersProvider.future);
        if (indexers == null) {
          throw UserIndexersNotFoundException();
        }

        final relays = _indexersAvoidingDislikedUrls(indexers, dislikedUrls);

        final lastUsedRelays = await _getLastUsedRelay(
          relays,
          dislikedUrls,
          actionSource.anonymous,
        );
        if (lastUsedRelays != null) return lastUsedRelays;

        final randomRelay = relays.random;
        if (randomRelay == null) {
          throw FailedToPickUserRelay();
        }

        return ref.read(relayProvider(randomRelay, anonymous: actionSource.anonymous).future);

      case ActionSourceRelayUrl():
        final relay = actionSource.url;

        final lastUsedRelays = await _getLastUsedRelay(
          [relay],
          dislikedUrls,
          actionSource.anonymous,
        );
        if (lastUsedRelays != null) return lastUsedRelays;

        return ref.read(relayProvider(relay, anonymous: actionSource.anonymous).future);
    }
  }

  Future<IonConnectRelay?> _getLastUsedRelay(
    List<String> userRelays,
    DislikedRelayUrlsCollection dislikedUrls,
    bool anonymous,
  ) async {
    final activeRelaysSet = ref.read(activeRelaysProvider);
    if (activeRelaysSet.isEmpty) return null;

    final availableRelays = userRelays
        .where(
          (relayUrl) => activeRelaysSet.contains(relayUrl) && !dislikedUrls.contains(relayUrl),
        )
        .toList();

    if (availableRelays.isEmpty) return null;

    return ref.read(relayProvider(availableRelays.first, anonymous: anonymous).future);
  }

  Future<UserRelaysEntity> _getCurrentUserRankedRelays() async {
    final relays = await ref.read(rankedCurrentUserRelaysProvider.future);
    if (relays == null || relays.urls.isEmpty) {
      throw UserRelaysNotFoundException();
    }
    return relays;
  }

  Future<UserRelaysEntity> _getCurrentUserRawRelays() async {
    final relays = await ref.read(currentUserRelaysProvider.future);
    if (relays == null || relays.urls.isEmpty) {
      throw UserRelaysNotFoundException();
    }
    return relays;
  }

  Future<UserRelaysEntity> _getUserRawRelays(String pubkey) async {
    final relays = await ref.watch(userRelaysManagerProvider.notifier).fetch([pubkey]);
    if (relays.isEmpty) {
      throw UserRelaysNotFoundException(pubkey);
    }
    return relays.first;
  }

  List<UserRelay> _userRelaysAvoidingDislikedUrls(
    List<UserRelay> relays,
    DislikedRelayUrlsCollection dislikedRelaysUrls,
  ) {
    final urls = relays.where((relay) => !dislikedRelaysUrls.contains(relay.url)).toList();
    if (urls.isEmpty) return relays;
    return urls;
  }

  List<String> _indexersAvoidingDislikedUrls(
    List<String> indexers,
    DislikedRelayUrlsCollection dislikedUrls,
  ) {
    var urls = indexers.where((indexer) => !dislikedUrls.contains(indexer)).toList();
    if (urls.isEmpty) {
      urls = indexers;
    }
    return urls;
  }

  Future<IonConnectRelay> _selectRelayForOtherUser(List<String> urls, bool anonymous) async {
    if (urls.length == 1) {
      return ref.read(relayProvider(urls.first, anonymous: anonymous).future);
    }

    final relevantRelays = await ref.read(rankedRelevantCurrentUserRelaysUrlsProvider.future);
    final commonRelays = relevantRelays.where((url) => urls.contains(url)).toList();
    if (relevantRelays.isEmpty || commonRelays.isEmpty) {
      final randomRelayUrl = urls.random;
      if (randomRelayUrl == null) {
        throw FailedToPickUserRelay();
      }
      return ref.read(relayProvider(randomRelayUrl, anonymous: anonymous).future);
    }

    return ref.read(relayProvider(commonRelays.first, anonymous: anonymous).future);
  }

  List<UserRelay> _filterWriteRelays(UserRelaysEntity relayEntity) {
    return relayEntity.data.list.where((relay) => relay.write).toList();
  }
}
