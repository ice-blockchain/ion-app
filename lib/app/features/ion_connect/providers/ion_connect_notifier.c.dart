// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/providers/main_wallet_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart' as ion;
import 'package:ion/app/features/ion_connect/ion_connect.dart' hide requestEvents;
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/relay_auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/relay_creation_provider.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/utils/retry.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_notifier.c.g.dart';

const _defaultTimeout = Duration(seconds: 30);

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
    _warnSendIssues(events);

    final dislikedRelaysUrls = <String>{};

    return withRetry(
      ({error}) async {
        relay ??= await ref
            .read(relayCreationProvider.notifier)
            .getRelay(actionSource, dislikedUrls: dislikedRelaysUrls);

        await ref
            .read(relayAuthProvider(relay!))
            .handleRelayAuthOnAction(actionSource: actionSource, error: error);

        await relay!.sendEvents(events).timeout(
              _defaultTimeout,
              onTimeout: () => throw TimeoutException(
                'Sending events timed out after ${_defaultTimeout.inSeconds} seconds',
              ),
            );

        if (cache) {
          return events.map(_parseAndCache).toList();
        }

        return null;
      },
      retryWhen: (error) =>
          error is RelayRequestFailedException || RelayAuthService.isRelayAuthError(error),
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
      cache: cache,
      relay: relay,
      actionSource: actionSource,
    );
    return result?.elementAtOrNull(0);
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

        await ref
            .read(relayAuthProvider(relay!))
            .handleRelayAuthOnAction(actionSource: actionSource, error: error);

        final events = subscriptionBuilder != null
            ? subscriptionBuilder(requestMessage, relay!)
            : ion.requestEvents(requestMessage, relay!);

        await for (final event in events) {
          // Note: The ion.requestEvents method automatically handles unsubscription for certain messages.
          // If the subscription needs to be retried or closed in response to a different message than those handled by ion.requestEvents,
          // then additional unsubscription logic should be implemented here.
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
      retryWhen: (error) =>
          error is RelayRequestFailedException || RelayAuthService.isRelayAuthError(error),
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
    // In case if we request an entity with the search extension, multiple events are returned.
    // To identity the needed one, entityEventReference might be user
    EventReference? entityEventReference,
  }) async {
    final entitiesStream = requestEntities<T>(requestMessage, actionSource: actionSource);

    final entities = await entitiesStream.toList();
    return entities.isNotEmpty
        ? entityEventReference != null
            ? entities.reversed
                .firstWhereOrNull((entity) => entity.toEventReference() == entityEventReference)
            : entities.last
        : null;
  }

  Future<EventMessage> sign(
    EventSerializable entityData, {
    bool includeMasterPubkey = true,
  }) async {
    final mainWallet = ref.read(mainWalletProvider).valueOrNull;

    if (mainWallet == null) {
      throw MainWalletNotFoundException();
    }

    final eventSigner = ref.read(currentUserIonConnectEventSignerProvider).valueOrNull;

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    return entityData.toEventMessage(
      eventSigner,
      tags: [
        if (includeMasterPubkey) ['b', mainWallet.signingKey.publicKey],
      ],
    );
  }

  Future<EventMessage> buildEventFromTagsAndSignWithMasterKey({
    required List<List<String>> tags,
    required int kind,
    required OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
  }) async {
    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);

    if (currentIdentityKeyName == null) {
      throw const CurrentUserNotFoundException();
    }

    final mainWallet = await ref.read(mainWalletProvider.future);
    final ionIdentity = await ref.read(ionIdentityProvider.future);

    if (mainWallet == null) {
      throw MainWalletNotFoundException();
    }

    final createdAt = DateTime.now();
    final masterPubkey = mainWallet.signingKey.publicKey;

    final eventId = EventMessage.calculateEventId(
      publicKey: masterPubkey,
      createdAt: createdAt,
      kind: kind,
      tags: tags,
      content: '',
    );

    final signResponse =
        await ionIdentity(username: currentIdentityKeyName).wallets.generateHashSignature(
              walletId: mainWallet.id,
              hash: eventId,
              onVerifyIdentity: onVerifyIdentity,
            );

    final curveName = switch (mainWallet.signingKey.curve) {
      'ed25519' => 'curve25519',
      _ => throw UnsupportedSignatureAlgorithmException(mainWallet.signingKey.curve)
    };

    final signaturePrefix = '${mainWallet.signingKey.scheme}/$curveName'.toLowerCase();
    final signatureBody =
        '${signResponse.signature['r']}${signResponse.signature['s']}'.replaceAll('0x', '');
    final signature = '$signaturePrefix:$signatureBody';

    return EventMessage(
      id: eventId,
      pubkey: masterPubkey,
      createdAt: createdAt,
      kind: kind,
      tags: tags,
      content: '',
      sig: signature,
    );
  }

  IonConnectEntity _parseAndCache(EventMessage event) {
    final parser = ref.read(eventParserProvider);
    final entity = parser.parse(event);
    if (entity is CacheableEntity) {
      ref.read(ionConnectCacheProvider.notifier).cache(entity);
    }
    return entity;
  }

  void _warnSendIssues(List<EventMessage> events) {
    final excludedKinds = [
      IonConnectGiftWrapServiceImpl.kind,
      FileMetadataEntity.kind,
      UserDelegationEntity.kind,
    ];
    for (final event in events) {
      if (!excludedKinds.contains(event.kind) && !event.tags.any((tag) => tag[0] == 'b')) {
        Logger.error(
          EventMasterPubkeyNotFoundException(eventId: event.id),
          stackTrace: StackTrace.current,
        );
      }
    }
  }
}
