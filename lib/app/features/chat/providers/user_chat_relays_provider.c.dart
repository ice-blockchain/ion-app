// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_chat_relays_provider.c.g.dart';

///
/// This provider is used to fetch the user chat relays for a given pubkey.
/// It is different from the [UserRelays] provider because it is used to fetch the user chat relays
///
@riverpod
class UserChatRelays extends _$UserChatRelays {
  @override
  Future<UserChatRelaysEntity?> build(String pubkey) async {
    final entity = ref.watch(
      nostrCacheProvider.select<UserChatRelaysEntity?>(
        cacheSelector(UserChatRelaysEntity.cacheKeyBuilder(pubkey: pubkey)),
      ),
    );
    if (entity != null) {
      return entity;
    }

    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(kinds: const [UserChatRelaysEntity.kind], authors: [pubkey]),
      );

    return ref.watch(nostrNotifierProvider.notifier).requestEntity<UserChatRelaysEntity>(
          requestMessage,
          actionSource: ActionSourceUser(pubkey),
        );
  }

  Future<void> setCurrentUserChatRelays() async {
    final pubkey = ref.watch(currentPubkeySelectorProvider);

    if (pubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final userRelays = await ref.watch(userRelaysManagerProvider.notifier).fetch([pubkey]);
    final relayUrls = userRelays.first.data.list.map((e) => e.url).toList();

    final userChatRelays = await ref.watch(userChatRelaysProvider(pubkey).future);

    if (userChatRelays != null) {
      final chatRelays = userChatRelays.data.list.map((e) => e.url).toList();
      if (chatRelays.toSet().containsAll(relayUrls) && relayUrls.toSet().containsAll(chatRelays)) {
        return;
      }
    }

    final chatRelays = UserChatRelaysData(
      list: relayUrls.map((url) => UserRelay(url: url)).toList(),
    );

    final chatRelaysEvent = await ref.read(nostrNotifierProvider.notifier).sign(chatRelays);

    await ref.read(nostrNotifierProvider.notifier).sendEvents([chatRelaysEvent]);
    ref.invalidateSelf();
  }
}
