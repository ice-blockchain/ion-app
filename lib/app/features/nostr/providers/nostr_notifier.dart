// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/providers/user_relays_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nostr_notifier.g.dart';

@riverpod
class NostrNotifier extends _$NostrNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> sendEvents(List<EventMessage> events, {String? pubkey}) async {
    final userRelays = pubkey != null
        ? (await ref.read(userRelaysProvider(pubkey).future))
        : (await ref.read(currentUserRelaysProvider.future));

    if (userRelays == null) {
      throw Exception('User relays are null');
    }

    final relay = await ref.read(relayProvider(userRelays.list.random.url).future);

    // await relay.sendEvents(events);
    // TODO: commented until relays implement it
    await Future.wait(events.map(relay.sendEvent).toList());
  }

  Future<void> sendEvent(EventMessage event, {String? pubkey}) async {
    return sendEvents([event], pubkey: pubkey);
  }
}
