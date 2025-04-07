// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
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
Future<UserRelaysEntity?> currentUserRelay(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return null;
  }
  return ref.watch(userRelayProvider(currentPubkey).future);
}

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
        ionConnectCacheProvider.select(
          cacheSelector<UserRelaysEntity>(
            CacheableEntity.cacheKeyBuilder(
              eventReference:
                  ReplaceableEventReference(pubkey: pubkey, kind: UserRelaysEntity.kind),
            ),
          ),
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
        .read(ionConnectNotifierProvider.notifier)
        .requestEntities(requestMessage, actionSource: actionSource);

    await for (final entity in entitiesStream) {
      if (entity is UserRelaysEntity) {
        result.add(entity);
        pubkeysToFetch.removeWhere((pubkey) {
          // In some corner cases we might use `pubkey` instead on `masterPubkey`,
          // For example for kind14 chat events that don't have masterPubkey
          return pubkey == entity.masterPubkey || pubkey == entity.pubkey;
        });
      }
    }

    if (pubkeysToFetch.isNotEmpty) {
      final userRelays = await _fetchRelaysFromIdentityFor(pubkeys: pubkeysToFetch);

      result.addAll(userRelays);
    }

    return result;
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
    ]..forEach(ref.read(ionConnectCacheProvider.notifier).cache);

    return userRelays;
  }
}
