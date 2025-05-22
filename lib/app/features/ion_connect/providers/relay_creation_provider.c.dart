// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/providers/user_chat_relays_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart' hide requestEvents;
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/disliked_relay_urls_collection.c.dart';
import 'package:ion/app/features/ion_connect/providers/active_relays_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/relay_provider.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.c.dart';
import 'package:ion/app/features/user/providers/relays_reachability_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_creation_provider.c.g.dart';

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

        final userRelays = await _getUserRelays(pubkey).then((userRelays) => userRelays.data.list);
        final relays = _userRelaysAvoidingDislikedUrls(userRelays, dislikedUrls)
            .map((relay) => relay.url)
            .toList();

        final lastUsedRelays = await _getLastUsedRelay(
          relays,
          dislikedUrls,
          actionSource.anonymous,
        );
        if (lastUsedRelays != null) return lastUsedRelays;

        return _getRelay(relays, actionSource.anonymous);

      case ActionSourceCurrentUserChat():
        final pubkey = ref.read(currentPubkeySelectorProvider);
        if (pubkey == null) {
          throw UserMasterPubkeyNotFoundException();
        }

        final userRelays =
            await _getUserChatRelays(pubkey).then((userChatRelays) => userChatRelays.data.list);

        final relays = _userRelaysAvoidingDislikedUrls(userRelays, dislikedUrls)
            .map((relay) => relay.url)
            .toList();

        final lastUsedRelays = await _getLastUsedRelay(
          relays,
          dislikedUrls,
          actionSource.anonymous,
        );
        if (lastUsedRelays != null) return lastUsedRelays;

        return _getRelay(relays, actionSource.anonymous);

      case ActionSourceUser():
        final userRelays =
            await _getUserRelays(actionSource.pubkey).then((userRelays) => userRelays.data.list);

        final relays = _userRelaysAvoidingDislikedUrls(userRelays, dislikedUrls)
            .map((relay) => relay.url)
            .toList();

        final lastUsedRelays = await _getLastUsedRelay(
          relays,
          dislikedUrls,
          actionSource.anonymous,
        );

        if (lastUsedRelays != null) return lastUsedRelays;

        return _getRelay(relays, actionSource.anonymous);

      case ActionSourceUserChat():
        final userChatRelays = await _getUserChatRelays(actionSource.pubkey);
        final relays = _userRelaysAvoidingDislikedUrls(userChatRelays.data.list, dislikedUrls)
            .map((relay) => relay.url)
            .toList();

        final lastUsedRelays = await _getLastUsedRelay(
          relays,
          dislikedUrls,
          actionSource.anonymous,
        );
        if (lastUsedRelays != null) return lastUsedRelays;

        return _getRelay(relays, actionSource.anonymous);

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

        return _getRelay(relays, actionSource.anonymous);

      case ActionSourceRelayUrl():
        final relay = actionSource.url;

        final lastUsedRelays = await _getLastUsedRelay(
          [relay],
          dislikedUrls,
          actionSource.anonymous,
        );
        if (lastUsedRelays != null) return lastUsedRelays;

        return _getRelay([relay], actionSource.anonymous);
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

    return _getRelay(availableRelays, anonymous);
  }

  Future<IonConnectRelay> _getRelay(List<String> urls, bool anonymous) async {
    if (urls.length == 1) {
      return ref.read(relayProvider(urls.first, anonymous: anonymous).future);
    }

    final reachabilityInfos = ref.read(relayReachabilityProvider.notifier).getAll(urls);
    if (reachabilityInfos.isEmpty) {
      return ref.read(relayProvider(urls.random, anonymous: anonymous).future);
    }

    final byHighestFailedCount = groupBy(reachabilityInfos, (info) => info.failedToReachCount);
    final highestFailedCount = byHighestFailedCount.keys.reduce((a, b) => a > b ? a : b);
    final highestFailedCountInfos = byHighestFailedCount[highestFailedCount]!;
    final highestFailedCountUrls = highestFailedCountInfos.map((info) => info.relayUrl).toList();

    return ref.read(relayProvider(highestFailedCountUrls.random, anonymous: anonymous).future);
  }

  Future<UserRelaysEntity> _getUserRelays(String pubkey) async {
    // For the current user, we use the relays from Identity as the single source of truth.
    // Unlike Connect relays, Identity relays are always up to date.
    final userRelays = ref.read(isCurrentUserSelectorProvider(pubkey))
        ? await ref.read(currentUserRelaysProvider.future)
        : await ref.read(userRelayProvider(pubkey).future);
    if (userRelays == null) {
      throw UserRelaysNotFoundException(pubkey);
    }
    return userRelays;
  }

  Future<UserChatRelaysEntity> _getUserChatRelays(String pubkey) async {
    final userRelays = await ref.read(userChatRelaysProvider(pubkey).future);
    if (userRelays == null) {
      throw UserChatRelaysNotFoundException();
    }
    return userRelays;
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
}
