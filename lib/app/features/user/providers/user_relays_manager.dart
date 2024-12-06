// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/user/model/user_relays.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_relays_manager.g.dart';

@riverpod
class UserRelaysManager extends _$UserRelaysManager {
  @override
  FutureOr<void> build() async {}

  Future<List<UserRelaysEntity>> fetch(
    List<String> pubkeys, {
    ActionSource actionSource = const ActionSourceIndexers(),
  }) async {
    final result = <UserRelaysEntity>[];
    final pubkeysToFetch = <String>[];

    for (final pubkey in pubkeys) {
      final cached = ref.read(
        nostrCacheProvider.select(
          cacheSelector<UserRelaysEntity>(UserRelaysEntity.cacheKeyBuilder(pubkey: pubkey)),
        ),
      );
      if (cached != null) {
        result.add(cached);
      } else {
        pubkeysToFetch.add(pubkey);
      }
    }

    if (pubkeysToFetch.isEmpty) {
      return result;
    }

    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(kinds: const [UserRelaysEntity.kind], authors: pubkeysToFetch),
      );

    final entitiesStream = ref
        .read(nostrNotifierProvider.notifier)
        .requestEntities(requestMessage, actionSource: actionSource);

    await for (final entity in entitiesStream) {
      if (entity is UserRelaysEntity) {
        result.add(entity);
        pubkeysToFetch.remove(entity.masterPubkey);
      }
    }

    if (pubkeysToFetch.isNotEmpty) {
      final userRelays = await _fetchRelaysFromIdentityFor(pubkeys: pubkeysToFetch);

      result.addAll(userRelays);
    }

    return result;
  }

  Future<UserRelaysEntity?> fetchForCurrentUser() async {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentPubkey == null) {
      return null;
    }
    final userRelays = await ref.read(userRelaysManagerProvider.notifier).fetch([currentPubkey]);
    if (userRelays.isEmpty) {
      return null;
    }
    return userRelays.first;
  }

  Future<List<UserRelaysEntity>> _fetchRelaysFromIdentityFor({
    required List<String> pubkeys,
  }) async {
    final ionIdentity = await ref.read(ionIdentityClientProvider.future);
    final userDetails = await Future.wait(
      pubkeys.map((pubkey) async {
        try {
          return await ionIdentity.users.details(userId: pubkey);
        } catch (error, stackTrace) {
          Logger.log('Error fetching user relays', error: error, stackTrace: stackTrace);
        }
      }),
    );
    final userRelays = [
      for (final details in userDetails)
        if (details != null && details.ionConnectRelays != null)
          UserRelaysEntity(
            id: '',
            signature: '',
            masterPubkey: details.masterPubKey,
            pubkey: details.masterPubKey,
            createdAt: DateTime.now(),
            data: UserRelaysData(
              list: details.ionConnectRelays!.map((url) => UserRelay(url: url)).toList(),
            ),
          ),
    ]..forEach(ref.read(nostrCacheProvider.notifier).cache);

    return userRelays;
  }
}
