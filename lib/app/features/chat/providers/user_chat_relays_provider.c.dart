// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_chat_relays_provider.c.g.dart';

///
/// This provider is used to fetch the user chat relays for a given pubkey.
/// It is different from the [UserRelays] provider because it is used to fetch the user chat relays
/// for a given pubkey with a specific random relay.
///
@riverpod
class UserChatRelays extends _$UserChatRelays {
  @override
  Future<UserChatRelaysEntity?> build(String pubkey) async {
    final requestMessage = RequestMessage()
      ..addFilter(
        const RequestFilter(kinds: [UserChatRelaysEntity.kind]),
      );

    final entity = await ref
        .read(nostrNotifierProvider.notifier)
        .requestEntity<UserChatRelaysEntity>(requestMessage);

    return entity;
  }

  ///
  /// Returns the random relay url for the user chat relays.
  ///
  Future<String?> getRandomRelayUrl() async {
    final value = await future;
    return value?.data.list.random.url;
  }
}
