// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/providers/user_chat_relays_provider.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_event_signer_provider.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_user_chat_relays_provider.c.g.dart';

///
/// This provider is used to set the user chat relays for a given pubkey.
/// It copies the user relays to the user chat relays and sends the event to the relay.
///
@riverpod
Future<void> setUserChatRelays(
  Ref ref, {
  required String pubkey,
}) async {
  final eventSigner = ref.read(currentUserNostrEventSignerProvider).valueOrNull;

  if (eventSigner == null) {
    throw EventSignerNotFoundException();
  }

  final userRelays = await ref.read(userRelaysManagerProvider.notifier).fetchForCurrentUser();

  if (userRelays == null) {
    throw UserRelaysNotFoundException();
  }

  final eventMessage =
      await UserChatRelaysData(list: userRelays.data.list).toEventMessage(eventSigner);

  await ref.read(nostrNotifierProvider.notifier).sendEvent(eventMessage);
  ref.invalidate(userChatRelaysProvider(pubkey));
}
