// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart' as ion;
import 'package:ion/app/features/ion_connect/ion_connect.dart' hide requestEvents;
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/auth_event.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/auth_challenge_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/relay_creation_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/wallets/main_wallet_provider.c.dart';
import 'package:ion/app/utils/retry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_notifier.c.g.dart';

@riverpod
class IonConnectNotifier extends _$IonConnectNotifier {
  @override
  FutureOr<void> build() {}

  Future<List<IonConnectEntity>?> sendEvents(
    List<EventMessage> events, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
    bool cache = true,
    IonConnectRelay? relay,
  }) async {
    final dislikedRelaysUrls = <String>{};

    return withRetry(
      ({error}) async {
        relay ??= await ref
            .read(relayCreationProvider.notifier)
            .getRelay(actionSource, dislikedUrls: dislikedRelaysUrls);

        if (_isAuthRequired(error)) {
          await sendAuthEvent(relay!);
        }

        await relay!.sendEvents(events);

        if (cache) {
          return events.map(_parseAndCache).toList();
        }

        return null;
      },
      retryWhen: (error) => error is RelayRequestFailedException || _isAuthRequired(error),
      onRetry: () {
        if (relay != null) dislikedRelaysUrls.add(relay!.url);
      },
    );
  }

  Future<IonConnectEntity?> sendEvent(
    EventMessage event, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
    bool cache = true,
    IonConnectRelay? relay,
  }) async {
    final result = await sendEvents(
      [event],
      actionSource: actionSource,
      cache: cache,
      relay: relay,
    );
    return result?.elementAtOrNull(0);
  }

  Future<void> sendAuthEvent(IonConnectRelay relay) async {
    final challenge = ref.read(authChallengeProvider(relay.url));
    if (challenge == null || challenge.isEmpty) throw AuthChallengeIsEmptyException();

    final signedAuthEvent = await createAuthEvent(
      challenge: challenge,
      relayUrl: Uri.parse(relay.url).toString(),
    );

    final authMessage = AuthMessage(
      challenge: jsonEncode(signedAuthEvent.toJson().last),
    );
    relay.sendMessage(authMessage);

    final okMessages = await relay.messages
        .where((message) => message is OkMessage)
        .cast<OkMessage>()
        .firstWhere((message) => signedAuthEvent.id == message.eventId);

    if (!okMessages.accepted) {
      throw SendEventException(okMessages.message);
    }

    ref.read(authChallengeProvider(relay.url).notifier).clearChallenge();
  }

  Future<EventMessage> createAuthEvent({
    required String challenge,
    required String relayUrl,
  }) async {
    final authEvent = AuthEvent(
      challenge: challenge,
      relay: relayUrl,
    );

    return sign(authEvent);
  }

  Future<List<IonConnectEntity>?> sendEntitiesData(
    List<EventSerializable> entitiesData, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
    bool cache = true,
  }) async {
    final events = await Future.wait(entitiesData.map(sign));
    return sendEvents(events, actionSource: actionSource, cache: cache);
  }

  Future<T?> sendEntityData<T extends IonConnectEntity>(
    EventSerializable entityData, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
    bool cache = true,
  }) async {
    final entities = await sendEntitiesData([entityData], actionSource: actionSource, cache: cache);
    return entities?.elementAtOrNull(0) as T?;
  }

  Stream<EventMessage> requestEvents(
    RequestMessage requestMessage, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
    Stream<RelayMessage> Function(RequestMessage requestMessage, NostrRelay relay)?
        subscriptionBuilder,
  }) async* {
    final dislikedRelaysUrls = <String>{};
    IonConnectRelay? relay;

    yield* withRetryStream(
      ({error}) async* {
        relay = await ref
            .read(relayCreationProvider.notifier)
            .getRelay(actionSource, dislikedUrls: dislikedRelaysUrls);

        if (_isAuthRequired(error)) {
          try {
            // TODO: handle multiple auth requests to one connectoon properly
            await sendAuthEvent(relay!);
          } catch (error, stackTrace) {
            Logger.log('Send auth exception', error: error, stackTrace: stackTrace);
          }
        }

        final events = subscriptionBuilder != null
            ? subscriptionBuilder(requestMessage, relay!)
            : ion.requestEvents(requestMessage, relay!);

        await for (final event in events) {
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
      retryWhen: (error) => error is RelayRequestFailedException || _isAuthRequired(error),
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

  Stream<T> requestEntities<T extends IonConnectEntity>(
    RequestMessage requestMessage, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async* {
    await for (final event in requestEvents(requestMessage, actionSource: actionSource)) {
      try {
        yield _parseAndCache(event) as T;
      } catch (error, stackTrace) {
        Logger.log('Failed to process event ${event.id}', error: error, stackTrace: stackTrace);
      }
    }
  }

  Future<T?> requestEntity<T extends IonConnectEntity>(
    RequestMessage requestMessage, {
    ActionSource actionSource = const ActionSourceCurrentUser(),
  }) async {
    final entitiesStream = requestEntities(requestMessage, actionSource: actionSource);
    final entities = await entitiesStream.toList();
    return entities.isNotEmpty ? entities.first as T : null;
  }

  Future<EventMessage> sign(EventSerializable entityData) async {
    final eventSigner = ref.read(currentUserIonConnectEventSignerProvider).valueOrNull;
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

  bool _isAuthRequired(Object? error) {
    final isSubscriptionAuthRequired = error is RelayRequestFailedException &&
        error.event is ClosedMessage &&
        (error.event as ClosedMessage).message.startsWith('auth-required');
    final isSendEventAuthRequired =
        error != null && (error is SendEventException) && error.code.startsWith('auth-required');
    return isSubscriptionAuthRequired || isSendEventAuthRequired;
  }

  IonConnectEntity _parseAndCache(EventMessage event) {
    final parser = ref.read(eventParserProvider);
    final entity = parser.parse(event);
    if (entity is CacheableEntity) {
      ref.read(ionConnectCacheProvider.notifier).cache(entity);
    }
    return entity;
  }
}
