// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/nostr/model/action_source.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/providers/current_user_indexers_provider.dart';
import 'package:ice/app/features/user/providers/user_relays_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nostr_notifier.g.dart';

@riverpod
class NostrNotifier extends _$NostrNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> send(
    List<EventMessage> events, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async {
    final relay = await _getRelay(actionSource);
    // await relay.sendEvents(events);
    // TODO: commented until relays implement it
    await Future.wait(events.map(relay.sendEvent).toList());
  }

  Future<void> sendOne(
    EventMessage event, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async {
    return send([event], actionSource: actionSource);
  }

  Future<Stream<EventMessage>> request(
    RequestMessage requestMessage, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async {
    final relay = await _getRelay(actionSource);
    return requestEvents(requestMessage, relay);
  }

  Future<EventMessage?> requestOne(
    RequestMessage requestMessage, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async {
    final eventsStream = await request(requestMessage, actionSource: actionSource);
    final events = await eventsStream.toList();
    return events.isNotEmpty ? events.first : null;
  }

  Future<NostrRelay> _getRelay(ActionSource actionSource) async {
    final relayUrl = switch (actionSource) {
      ActionSourceCurrentUser() =>
        (await ref.read(currentUserRelaysProvider.future))?.list.random.url,
      ActionSourceIndexers() => (await ref.read(currentUserIndexersProvider.future))?.random,
      ActionSourceUser() =>
        (await ref.read(userRelaysProvider(actionSource.pubkey).future))?.list.random.url,
    };

    if (relayUrl == null) {
      throw Exception('Relay URL for $actionSource is not found');
    }

    return await ref.read(relayProvider(relayUrl).future);
  }
}
