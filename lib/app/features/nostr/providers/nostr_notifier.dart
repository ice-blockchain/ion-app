// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_event_parser.dart';
import 'package:ion/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ion/app/features/nostr/providers/relays_provider.dart';
import 'package:ion/app/features/user/model/user_relays.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.dart';
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
    // TODO: uncomment when our relays are used
    await Future.wait(events.map(relay.sendEvent).toList());
  }

  Future<void> sendOne(
    EventMessage event, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async {
    return send([event], actionSource: actionSource);
  }

  Stream<EventMessage> request(
    RequestMessage requestMessage, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async* {
    final relay = await _getRelay(actionSource);
    yield* requestEvents(requestMessage, relay);
  }

  Stream<NostrEntity> requestEntities(
    RequestMessage requestMessage, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async* {
    final parser = ref.read(eventParserProvider);
    final cacheNotifier = ref.read(nostrCacheProvider.notifier);
    await for (final event in request(requestMessage, actionSource: actionSource)) {
      final entity = parser.parse(event);
      if (entity is CacheableEntity) {
        cacheNotifier.cache(entity as CacheableEntity);
      }
      yield entity;
    }
  }

  Future<EventMessage?> requestOne(
    RequestMessage requestMessage, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async {
    final eventsStream = request(requestMessage, actionSource: actionSource);
    final events = await eventsStream.toList();
    return events.isNotEmpty ? events.first : null;
  }

  Future<NostrRelay> _getRelay(ActionSource actionSource) async {
    switch (actionSource) {
      case ActionSourceCurrentUser():
        {
          final keyStore = await ref.read(currentUserNostrKeyStoreProvider.future);
          if (keyStore == null) {
            throw Exception('Current user keystore is not found');
          }
          final userRelays = await getUserRelays(keyStore.publicKey);
          return await ref.read(relayProvider(userRelays.data.list.random.url).future);
        }
      case ActionSourceUser():
        {
          final userRelays = await getUserRelays(actionSource.pubkey);
          return await ref.read(relayProvider(userRelays.data.list.random.url).future);
        }
      case ActionSourceIndexers():
        {
          final indexers = await ref.read(currentUserIndexersProvider.future);
          if (indexers == null) {
            throw UserRelaysNotFoundException();
          }
          return await ref.read(relayProvider(indexers.random).future);
        }
    }
  }

  Future<UserRelaysEntity> getUserRelays(String pubkey) async {
    final cached = ref.read(nostrCacheProvider.select(cacheSelector<UserRelaysEntity>(pubkey)));
    if (cached != null) {
      return cached;
    }

    final requestMessage = RequestMessage()
      ..addFilter(RequestFilter(kinds: const [UserRelaysEntity.kind], authors: [pubkey], limit: 1));

    final event = await ref.read(nostrNotifierProvider.notifier).requestOne(
          requestMessage,
          actionSource: const ActionSourceIndexers(),
        );

    if (event != null) {
      //TODO:uncomment when our relays are used, using damus by then as the fastest one
      // final userRelays = UserRelays.fromEventMessage(event);
      final userRelays = UserRelaysEntity(
        id: '',
        createdAt: DateTime.now(),
        pubkey: pubkey,
        data: const UserRelaysData(list: [UserRelay(url: 'wss://relay.nostr.band')]),
      );
      ref.read(nostrCacheProvider.notifier).cache(userRelays);
      return userRelays;
    }
    //TODO:
    // else
    // request to identity->get-user for the provided `pubkey` when implemented
    // and return them here if found:
    // ref.read(nostrCacheProvider.notifier).cache(userRelays);
    // return ...

    throw UserRelaysNotFoundException();
  }
}

class UserRelaysNotFoundException implements Exception {
  UserRelaysNotFoundException([this.message = 'User relays are not found']);

  final String message;
}
