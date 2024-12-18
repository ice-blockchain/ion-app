// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_event_parser.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_event_signer_provider.c.dart';
import 'package:ion/app/features/nostr/providers/relays_provider.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:ion/app/features/wallets/providers/main_wallet_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/utils/retry.dart';
import 'package:nostr_dart/nostr_dart.dart' as nd;
import 'package:nostr_dart/nostr_dart.dart' hide requestEvents;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nostr_notifier.c.g.dart';

@riverpod
class NostrNotifier extends _$NostrNotifier {
  @override
  FutureOr<void> build() {}

  Future<List<NostrEntity>?> sendEvents(
    List<EventMessage> events, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
    bool cache = true,
  }) async {
    final dislikedRelaysUrls = <String>{};
    NostrRelay? relay;
    return withRetry(
      () async {
        relay = await _getRelay(actionSource, dislikedUrls: dislikedRelaysUrls);
        await relay!.sendEvents(events);
        if (cache) {
          return events.map(_parseAndCache).toList();
        }
        return null;
      },
      retryWhen: (error) => error is RelayRequestFailedException,
      onRetry: () {
        if (relay != null) dislikedRelaysUrls.add(relay!.url);
      },
    );
  }

  Future<NostrEntity?> sendEvent(
    EventMessage event, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
    bool cache = true,
  }) async {
    final result = await sendEvents([event], actionSource: actionSource, cache: cache);
    return result?.elementAtOrNull(0);
  }

  Future<List<NostrEntity>?> sendEntitiesData(
    List<EventSerializable> entitiesData, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
    bool cache = true,
  }) async {
    final events = await Future.wait(entitiesData.map(sign));
    return sendEvents(events, actionSource: actionSource, cache: cache);
  }

  Future<NostrEntity?> sendEntityData(
    EventSerializable entityData, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
    bool cache = true,
  }) async {
    final entities = await sendEntitiesData([entityData], actionSource: actionSource, cache: cache);
    return entities?.elementAtOrNull(0);
  }

  Stream<EventMessage> requestEvents(
    RequestMessage requestMessage, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async* {
    final dislikedRelaysUrls = <String>{};
    NostrRelay? relay;

    yield* withRetryStream(
      () async* {
        relay = await _getRelay(actionSource, dislikedUrls: dislikedRelaysUrls);
        await for (final event in nd.requestEvents(requestMessage, relay!)) {
          if (event is NoticeMessage || event is ClosedMessage) {
            throw RelayRequestFailedException(
              relayUrl: relay!.url,
              event: event,
            );
          } else if (event is EventMessage) {
            yield event;
          }
        }
      },
      retryWhen: (error) => error is RelayRequestFailedException,
      onRetry: () {
        if (relay != null) dislikedRelaysUrls.add(relay!.url);
      },
    );
  }

  Future<EventMessage?> requestEvent(
    RequestMessage requestMessage, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async {
    final eventsStream = requestEvents(requestMessage, actionSource: actionSource);
    final events = await eventsStream.toList();
    return events.isNotEmpty ? events.first : null;
  }

  Stream<NostrEntity> requestEntities(
    RequestMessage requestMessage, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async* {
    await for (final event in requestEvents(requestMessage, actionSource: actionSource)) {
      try {
        yield _parseAndCache(event);
      } catch (error, stackTrace) {
        Logger.log('Failed to process event ${event.id}', error: error, stackTrace: stackTrace);
      }
    }
  }

  Future<T?> requestEntity<T extends NostrEntity>(
    RequestMessage requestMessage, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async {
    final entitiesStream = requestEntities(requestMessage, actionSource: actionSource);
    final entities = await entitiesStream.toList();
    return entities.isNotEmpty ? entities.first as T : null;
  }

  Future<EventCountResultEntity> requestCount(
    EventCountRequestData requestData, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async {
    final requestEventMessage = await sign(requestData);
    final relay = await _getRelay(actionSource);
    relay.sendMessage(requestEventMessage);
    return relay.messages
        .where((message) => message is EventMessage && message.kind == EventCountResultEntity.kind)
        .cast<EventMessage>()
        .map(EventCountResultEntity.fromEventMessage)
        .firstWhere(
          (countResult) => countResult.data.requestEventId == requestEventMessage.id,
        );
  }

  Future<EventMessage> sign(EventSerializable entityData) async {
    final eventSigner = ref.read(currentUserNostrEventSignerProvider).valueOrNull;
    final mainWallet = ref.read(mainWalletProvider).valueOrNull;

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    if (mainWallet == null) {
      throw MainWalletNotFoundException();
    }

    return entityData.toEventMessage(
      eventSigner,
      tags: [
        ['b', mainWallet.signingKey.publicKey],
      ],
    );
  }

  Future<NostrRelay> _getRelay(
    ActionSource actionSource, {
    Set<String> dislikedUrls = const {},
  }) async {
    switch (actionSource) {
      case ActionSourceCurrentUser():
        {
          final pubkey = ref.read(currentPubkeySelectorProvider);
          if (pubkey == null) {
            throw UserMasterPubkeyNotFoundException();
          }
          final userRelays = await _getUserRelays(pubkey);
          final relays = _userRelaysAvoidingDislikedUrls(userRelays.data.list, dislikedUrls);
          return await ref.read(relayProvider(relays.random.url).future);
        }
      case ActionSourceUser():
        {
          final userRelays = await _getUserRelays(actionSource.pubkey);
          final relays = _userRelaysAvoidingDislikedUrls(userRelays.data.list, dislikedUrls);
          return await ref.read(relayProvider(relays.random.url).future);
        }
      case ActionSourceIndexers():
        {
          final indexers = await ref.read(currentUserIndexersProvider.future);
          if (indexers == null) {
            throw UserIndexersNotFoundException();
          }
          final urls = _indexersAvoidingDislikedUrls(indexers, dislikedUrls);
          return await ref.read(relayProvider(urls.random).future);
        }
      case ActionSourceRelayUrl():
        {
          // TODO: support multiple urls to allow retrying on different relays
          return await ref.read(relayProvider(actionSource.url).future);
        }
    }
  }

  // TODO:process cuncurrent calls to this method for the same pubkey (when opening a profile screen)
  Future<UserRelaysEntity> _getUserRelays(String pubkey) async {
    final userRelays = await ref.read(userRelaysManagerProvider.notifier).fetch([pubkey]);
    if (userRelays.isEmpty) {
      throw UserRelaysNotFoundException();
    }
    return userRelays.first;
  }

  NostrEntity _parseAndCache(EventMessage event) {
    final parser = ref.read(eventParserProvider);
    final entity = parser.parse(event);
    if (entity is CacheableEntity) {
      ref.read(nostrCacheProvider.notifier).cache(entity);
    }
    return entity;
  }

  List<UserRelay> _userRelaysAvoidingDislikedUrls(
    List<UserRelay> relays,
    Set<String> dislikedRelaysUrls,
  ) {
    final urls = relays.where((relay) => !dislikedRelaysUrls.contains(relay.url)).toList();
    if (urls.isEmpty) return relays;
    return urls;
  }

  List<String> _indexersAvoidingDislikedUrls(List<String> indexers, Set<String> dislikedUrls) {
    var urls = indexers.where((indexer) => !dislikedUrls.contains(indexer)).toList();
    if (urls.isEmpty) {
      urls = indexers;
    }
    return urls;
  }
}
