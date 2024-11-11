// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ion/app/features/user/model/user_relays.dart';
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
    //TODO::remove this stub and uncomment the rest as soon as we use our relays
    return List.generate(pubkeys.length, (index) {
      return UserRelaysEntity(
        createdAt: DateTime.now(),
        id: '',
        pubkey: pubkeys[index],
        data: const UserRelaysData(list: [UserRelay(url: 'wss://relay.nostr.band')]),
      );
    });

    // final result = <UserRelaysEntity>[];
    // final pubkeysToFetch = <String>[];

    // for (final pubkey in pubkeys) {
    //   final cached = ref.read(nostrCacheProvider.select(cacheSelector<UserRelaysEntity>(pubkey)));
    //   if (cached != null) {
    //     result.add(cached);
    //   } else {
    //     pubkeysToFetch.add(pubkey);
    //   }
    // }

    // if (pubkeysToFetch.isEmpty) {
    //   return result;
    // }

    // final requestMessage = RequestMessage()
    //   ..addFilter(
    //     RequestFilter(kinds: const [UserRelaysEntity.kind], authors: pubkeysToFetch),
    //   );

    // final entitiesStream = ref
    //     .read(nostrNotifierProvider.notifier)
    //     .requestEntities(requestMessage, actionSource: actionSource);

    // await for (final entity in entitiesStream) {
    //   if (entity is UserRelaysEntity) {
    //     result.add(entity);
    //   }
    // }

    // // if (userRelays == null) {
    // //TODO:
    // // request to identity->get-user for the provided `pubkey` when implemented
    // // and return them here if found:
    // // ref.read(nostrCacheProvider.notifier).cache(userRelays);
    // // return ...
    // // }

    // return result;
  }

  Future<UserRelaysEntity?> fetchForCurrentUser() async {
    final keyStore = await ref.read(currentUserNostrKeyStoreProvider.future);
    if (keyStore == null) {
      return null;
    }
    final userRelays =
        await ref.read(userRelaysManagerProvider.notifier).fetch([keyStore.publicKey]);
    if (userRelays.isEmpty) {
      return null;
    }
    return userRelays.first;
  }
}
