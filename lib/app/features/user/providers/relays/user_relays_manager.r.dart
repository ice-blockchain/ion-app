// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_db_cache_notifier.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.r.dart';
import 'package:ion/app/features/user/model/user_relays.f.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.r.dart';
import 'package:ion/app/features/user/providers/relays_reachability_provider.r.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_relays_manager.r.g.dart';

/// Finds the relays for the given user pubkeys.
///
/// Use this method when you need to find relays for a specific user or users.
/// Returns a list of user relays for each provided pubkey.
///
/// If a relay list is already cached in the database,
///   it will be returned from there (excluding unreachable relay urls).
/// If a relay list is not found in the database,
///   it will be fetched from indexers and cached.
/// If a relay list is still not found,
///   it will be fetched from the identity and cached.
@riverpod
class UserRelaysManager extends _$UserRelaysManager {
  @override
  FutureOr<void> build() async {}

  Future<List<UserRelaysEntity>> fetch(List<String> pubkeys) async {
    final result = <UserRelaysEntity>[];
    final pubkeysToFetch = [...pubkeys];

    final dbCachedRelays = await _getRelaysFromDb(pubkeys: pubkeys);
    final validDbCachedRelays = _filterValidRelays(dbCachedRelays);
    result.addAll(validDbCachedRelays);

    pubkeysToFetch
        .removeWhere((pubkey) => validDbCachedRelays.any((relay) => relay.masterPubkey == pubkey));

    if (pubkeysToFetch.isEmpty) {
      return result;
    }

    final fetchedRelays = <UserRelaysEntity>[];

    final relaysFromIndexers = await _fetchRelaysFromIndexers(pubkeys: pubkeysToFetch);
    final validRelaysFromIndexers = _filterValidRelays(relaysFromIndexers);

    fetchedRelays.addAll(validRelaysFromIndexers);
    result.addAll(validRelaysFromIndexers);

    pubkeysToFetch.removeWhere(
      (pubkey) => validRelaysFromIndexers.any((relay) => relay.masterPubkey == pubkey),
    );

    if (pubkeysToFetch.isEmpty) {
      return result;
    }

    final relaysFromIdentity = await _fetchRelaysFromIdentity(pubkeys: pubkeysToFetch);

    fetchedRelays.addAll(relaysFromIdentity);
    result.addAll(relaysFromIdentity);

    await _clearReachabilityInfoFor(fetchedRelays);

    return result;
  }

  Future<void> markRelayInDbAsReadOnly(String relayUrl) async {
    final outdatedEntities = (await ref
            .read(ionConnectDbCacheProvider.notifier)
            .getFiltered(query: relayUrl, kinds: [UserRelaysEntity.kind]))
        .cast<UserRelaysEntity?>()
        .nonNulls
        .toList();

    final updatedEntities = outdatedEntities
        .map(
          (entity) => entity.copyWith(
            data: entity.data.copyWith(
              list: entity.data.list
                  .map((relay) => relay.url == relayUrl ? relay.copyWith(write: false) : relay)
                  .toList(),
            ),
          ),
        )
        .toList();

    await ref.read(ionConnectDbCacheProvider.notifier).saveAll(updatedEntities);
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
    final eventReferences = pubkeys
        .map(
          (pubkey) => ReplaceableEventReference(
            masterPubkey: pubkey,
            kind: UserRelaysEntity.kind,
          ),
        )
        .toList();

    return (await ref.read(ionConnectDbCacheProvider.notifier).getAll(eventReferences))
        .cast<UserRelaysEntity?>()
        .nonNulls
        .toList();
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
              list: details.ionConnectRelays!.map((relay) => relay.toUserRelay()).toList(),
            ),
          ),
    ]..forEach(ref.read(ionConnectCacheProvider.notifier).cache);

    return userRelays;
  }

  List<UserRelaysEntity> _filterValidRelays(List<UserRelaysEntity> relays) {
    // Remove unreachable relays from relay lists
    final reachableRelays = relays
        .map(ref.read(relayReachabilityProvider.notifier).getFilteredRelayEntity)
        .nonNulls
        .toList();

    // Relay list is invalid if all relays are read-only.
    // That might be a case if user has outdated relay list
    // published to the ion-connect or in the local DB.
    return reachableRelays
        .where((relayEntity) => relayEntity.data.list.any((relay) => relay.write))
        .toList();
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

  static bool isRelayReadOnlyError(Object? error) {
    return error is SendEventException && error.code.startsWith('relay-is-read-only');
  }

  static bool relayListsEqual(List<UserRelay>? list1, List<UserRelay>? list2) {
    return const UnorderedIterableEquality<UserRelay>().equals(list1, list2);
  }
}

@riverpod
Future<UserRelaysEntity?> currentUserRelays(Ref ref) async {
  final identityConnectRelays = await ref.watch(currentUserIdentityConnectRelaysProvider.future);
  if (identityConnectRelays == null) {
    return null;
  }
  final updatedUserRelays = UserRelaysData(list: identityConnectRelays);
  final userRelaysEvent =
      await ref.read(ionConnectNotifierProvider.notifier).sign(updatedUserRelays);

  return UserRelaysEntity.fromEventMessage(userRelaysEvent);
}
