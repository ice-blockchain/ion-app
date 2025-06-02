// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_db_cache_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.c.dart';
import 'package:ion/app/features/user/providers/relays_reachability_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_relays_manager.c.g.dart';

@riverpod
Future<UserRelaysEntity?> userRelay(Ref ref, String pubkey) async {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    throw const CurrentUserNotFoundException();
  }
  final relays = await ref.watch(userRelaysManagerProvider.notifier).fetch([pubkey]);
  return relays.elementAtOrNull(0);
}

@riverpod
Future<UserRelaysEntity?> currentUserRelays(Ref ref) async {
  final userIdentity = await ref.watch(currentUserIdentityProvider.future);
  final identityConnectRelays = userIdentity?.ionConnectRelays;
  if (userIdentity == null || identityConnectRelays == null) {
    return null;
  }
  final updatedUserRelays = UserRelaysData(
    list: identityConnectRelays.map((url) => UserRelay(url: url)).toList(),
  );
  final userRelaysEvent =
      await ref.read(ionConnectNotifierProvider.notifier).sign(updatedUserRelays);

  return UserRelaysEntity.fromEventMessage(userRelaysEvent);
}

@riverpod
class UserRelaysManager extends _$UserRelaysManager {
  @override
  FutureOr<void> build() async {}

  Future<List<UserRelaysEntity>> fetch(List<String> pubkeys) async {
    final result = <UserRelaysEntity>[];
    final pubkeysToFetch = [...pubkeys];

    final dbCachedRelays = await _getRelaysFromDb(pubkeys: pubkeys);
    result.addAll(dbCachedRelays);

    pubkeysToFetch
        .removeWhere((pubkey) => dbCachedRelays.any((relay) => relay.masterPubkey == pubkey));

    if (pubkeysToFetch.isEmpty) {
      return result;
    }

    final fetchedRelays = <UserRelaysEntity>[];

    final relaysFromIndexers = await _fetchRelaysFromIndexers(pubkeys: pubkeysToFetch);

    fetchedRelays.addAll(relaysFromIndexers);
    result.addAll(relaysFromIndexers);

    pubkeysToFetch
        .removeWhere((pubkey) => relaysFromIndexers.any((relay) => relay.masterPubkey == pubkey));

    if (pubkeysToFetch.isEmpty) {
      return result;
    }

    final relaysFromIdentity = await _fetchRelaysFromIdentity(pubkeys: pubkeysToFetch);

    fetchedRelays.addAll(relaysFromIdentity);
    result.addAll(relaysFromIdentity);

    await _clearReachabilityInfoFor(fetchedRelays);

    return result;
  }

  Future<List<UserRelaysEntity>> _fetchRelaysFromIndexers({
    required List<String> pubkeys,
  }) async {
    final result = <UserRelaysEntity>[];
    final indexers = await ref.read(currentUserIndexersProvider.future);
    if (indexers != null && indexers.isNotEmpty) {
      final requestMessage = RequestMessage()
        ..addFilter(
          RequestFilter(kinds: const [UserRelaysEntity.kind], authors: pubkeys),
        );

      final entitiesStream = ref
          .read(ionConnectNotifierProvider.notifier)
          .requestEntities(requestMessage, actionSource: const ActionSourceIndexers());

      await for (final entity in entitiesStream) {
        if (entity is UserRelaysEntity) {
          result.add(entity);
        }
      }
    }
    return result;
  }

  Future<List<UserRelaysEntity>> _getRelaysFromDb({
    required List<String> pubkeys,
  }) async {
    final result = <UserRelaysEntity>[];

    final eventReferences = pubkeys
        .map(
          (pubkey) => ReplaceableEventReference(
            pubkey: pubkey,
            kind: UserRelaysEntity.kind,
          ),
        )
        .toList();

    final dbCachedRelays =
        (await ref.read(ionConnectDbCacheProvider.notifier).getAll(eventReferences))
            .cast<UserRelaysEntity?>()
            .nonNulls
            .toList();

    // Remove unreachable relays
    for (final relay in dbCachedRelays) {
      final filteredRelayEntity =
          ref.read(relayReachabilityProvider.notifier).getFilteredRelayEntity(relay);
      if (filteredRelayEntity != null) {
        result.add(filteredRelayEntity);
      }
    }

    return result;
  }

  Future<List<UserRelaysEntity>> _fetchRelaysFromIdentity({
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
            createdAt: DateTime.now().microsecondsSinceEpoch,
            data: UserRelaysData(
              list: details.ionConnectRelays!.map((url) => UserRelay(url: url)).toList(),
            ),
          ),
    ]..forEach(ref.read(ionConnectCacheProvider.notifier).cache);

    return userRelays;
  }

  Future<void> _clearReachabilityInfoFor(
    List<UserRelaysEntity> relays,
  ) async {
    final reachabilityInfoNotifier = ref.read(relayReachabilityProvider.notifier);
    final relayUrls = relays.map((relay) => relay.urls).expand((element) => element).toSet();
    for (final url in relayUrls) {
      await reachabilityInfoNotifier.clear(url);
    }
  }
}
