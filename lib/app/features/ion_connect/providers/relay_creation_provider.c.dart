// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/providers/user_chat_relays_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart' hide requestEvents;
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/providers/active_relays_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/relays_provider.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_creation_provider.c.g.dart';

@riverpod
class RelayCreation extends _$RelayCreation {
  @override
  FutureOr<void> build() {}

  Future<IonConnectRelay> getRelay(
    ActionSource actionSource, {
    Set<String> dislikedUrls = const {},
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

        return _getRelay(relays.random, actionSource.anonymous);

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

        return _getRelay(relays.random, actionSource.anonymous);

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

        return _getRelay(relays.random, actionSource.anonymous);

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

        return _getRelay(relays.random, actionSource.anonymous);

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

        return _getRelay(relays.random, actionSource.anonymous);

      case ActionSourceRelayUrl():
        final relay = actionSource.url;

        final lastUsedRelays = await _getLastUsedRelay(
          [relay],
          dislikedUrls,
          actionSource.anonymous,
        );
        if (lastUsedRelays != null) return lastUsedRelays;

        return _getRelay(relay, actionSource.anonymous);
    }
  }

  Future<IonConnectRelay?> _getLastUsedRelay(
    List<String> userRelays,
    Set<String> dislikedUrls,
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

    return await ref.read(
      relayProvider(availableRelays.random, anonymous: anonymous).future,
    );
  }

  Future<IonConnectRelay> _getRelay(String url, bool anonymous) async {
    return await ref.read(relayProvider(url, anonymous: anonymous).future);
  }

  Future<UserRelaysEntity> _getUserRelays(String pubkey) async {
    final userRelays = ref.read(isCurrentUserSelectorProvider(pubkey))
        ? await ref.read(currentUserIdentityRelaysProvider.future)
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
    Set<String> dislikedRelaysUrls,
  ) {
    final urls = relays.where((relay) => !dislikedRelaysUrls.contains(relay.url)).toList();
    if (urls.isEmpty) return relays;
    return urls;
  }

  List<String> _indexersAvoidingDislikedUrls(List<String> indexers, Set<String> dislikedUrls) {
    var urls = indexers.where((indexer) => !dislikedUrls.contains(indexer)).toList();
    if (urls.isEmpty) {
      urls = indexers;
    }
    return urls;
  }
}
