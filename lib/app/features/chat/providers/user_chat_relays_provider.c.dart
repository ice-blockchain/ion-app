// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_chat_relays_provider.c.g.dart';

///
/// This provider is used to fetch the user chat relays for a given pubkey.
/// It is different from the [UserRelays] provider because it is used to fetch the user chat relays
///
@riverpod
Future<UserChatRelaysEntity?> userChatRelays(
  Ref ref,
  String pubkey,
) async {
  final requestMessage = RequestMessage()
    ..addFilter(
      const RequestFilter(kinds: [UserChatRelaysEntity.kind]),
    );

  final entity = await ref
      .watch(nostrNotifierProvider.notifier)
      .requestEntity<UserChatRelaysEntity>(requestMessage, actionSource: ActionSourceUser(pubkey));

  return entity;
}
