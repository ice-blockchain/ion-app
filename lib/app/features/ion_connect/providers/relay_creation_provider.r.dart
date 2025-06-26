// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart' hide requestEvents;
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/disliked_relay_urls_collection.f.dart';
import 'package:ion/app/features/ion_connect/providers/active_relays_provider.r.dart';
import 'package:ion/app/features/ion_connect/providers/relay_provider.r.dart';
import 'package:ion/app/features/user/model/user_relays.f.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.r.dart';
import 'package:ion/app/features/user/providers/ranked_user_relays_provider.r.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_creation_provider.r.g.dart';

@riverpod
class RelayCreation extends _$RelayCreation {
  @override
  FutureOr<void> build() {}

  Future<IonConnectRelay> getRelay(
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
          return getRelay(
            ActionSource.currentUser(anonymous: actionSource.anonymous),
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

        return ref.read(relayProvider(relays.random, anonymous: actionSource.anonymous).future);

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
    if (relays == null) {
      throw UserRelaysNotFoundException('current_user');
    }
    return relays;
  }

  Future<UserRelaysEntity> _getUserRawRelays(String pubkey) async {
    final relays = await ref.read(userRelayProvider(pubkey).future);
    if (relays == null) {
      throw UserRelaysNotFoundException(pubkey);
    }
    return relays;
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
      return ref.read(relayProvider(urls.random, anonymous: anonymous).future);
    }

    return ref.read(relayProvider(commonRelays.first, anonymous: anonymous).future);
  }
}
