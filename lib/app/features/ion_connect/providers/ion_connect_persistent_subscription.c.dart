// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/encrypted_event_message_handler.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_persistent_subscription.c.g.dart';

@Riverpod(keepAlive: true)
class IonConnectPersistentSubscription extends _$IonConnectPersistentSubscription {
  @override
  Future<void> build() async {
    final authState = await ref.watch(authProvider.future);
    final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;

    if (!authState.isAuthenticated || !delegationComplete) return;

    final latestEventTimestamp = ref.watch(persistentSubscriptionLatestEventTimestampProvider);
    await _fetchPreviousEvents(
      since: latestEventTimestamp.overlap,
    );

    unawaited(_subscribe());
  }

  Future<int?> _fetchPreviousEvents({
    int? since,
    int? until,
  }) async {
    try {
      final requestMessage = await _requestMessageBuilder(
        since: since,
        until: until,
      );

      final ionConnectNotifier = ref.watch(ionConnectNotifierProvider.notifier);
      final eventsStream = ionConnectNotifier.requestEvents(
        requestMessage,
      );

      var count = 0;
      int? recentEventCreatedAt;
      int? oldestEventCreatedAt;
      await for (final event in eventsStream) {
        //TODO: Remove this once we have a proper way to handle gift wrap events on relay
        if (event.kind == IonConnectGiftWrapEntity.kind) {
          continue;
        }
        await _handleEvent(event);
        count++;
        final eventCreatedAt = event.createdAt.toMicroseconds;

        if (recentEventCreatedAt == null || eventCreatedAt > recentEventCreatedAt) {
          recentEventCreatedAt = eventCreatedAt;
        }

        if (oldestEventCreatedAt == null || eventCreatedAt < oldestEventCreatedAt) {
          oldestEventCreatedAt = eventCreatedAt;
        }
      }

      if (recentEventCreatedAt != null) {
        await ref
            .read(persistentSubscriptionLatestEventTimestampProvider.notifier)
            .update(recentEventCreatedAt);
      }

      if (count == 0) {
        return until;
      }

      return _fetchPreviousEvents(
        since: since,
        until: oldestEventCreatedAt == null ? null : oldestEventCreatedAt - 1,
      );
    } catch (e) {
      throw PersistentSubscriptionException(e);
    }
  }

  Future<void> _subscribe() async {
    final latestEventTimestamp = ref.watch(persistentSubscriptionLatestEventTimestampProvider);
    final requestMessage = await _requestMessageBuilder(
      since: latestEventTimestamp,
    );
    //TODO: Remove this once we have a proper way to handle gift wrap events on relay
    requestMessage.filters[1] = requestMessage.filters[1]
        .copyWith(since: () => DateTime.now().microsecondsSinceEpoch.overlap);
    final stream = ref.watch(ionConnectEventsSubscriptionProvider(requestMessage));
    final subscription = stream.listen(_handleEvent);
    ref.onDispose(subscription.cancel);
  }

  Future<void> _handleEvent(
    EventMessage eventMessage,
  ) async {
    try {
      final dispatcher = await ref.watch(persistentEventDispatcherNotifierProvider.future);
      await dispatcher.dispatch(eventMessage);
    } catch (e) {
      throw PersistentSubscriptionEventMessageHandlingException(e);
    }
  }

  Future<RequestMessage> _requestMessageBuilder({
    int? since,
    int? until,
  }) async {
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);
    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }
    final currentUserDeviceKey = eventSigner.publicKey;

    return RequestMessage(
      filters: [
        RequestFilter(
          tags: {
            '#p': [
              [currentUserMasterPubkey],
            ],
          },
          since: since,
          until: until,
          limit: 50,
        ),
        RequestFilter(
          kinds: const [IonConnectGiftWrapEntity.kind],
          tags: {
            '#p': [
              [currentUserMasterPubkey, '', currentUserDeviceKey],
            ],
          },
          since: since?.overlap,
          until: until,
          limit: 50,
        ),
      ],
    );
  }
}

@riverpod
class PersistentSubscriptionLatestEventTimestamp
    extends _$PersistentSubscriptionLatestEventTimestamp {
  static const _latestEventTimestampKey = 'persistent_subscription_latest_event_timestamp';

  @override
  int? build() {
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    return ref
        .watch(userPreferencesServiceProvider(identityKeyName: currentUserMasterPubkey))
        .getValue<int>(_latestEventTimestampKey);
  }

  Future<void> update(int createdAt) async {
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    await ref
        .watch(userPreferencesServiceProvider(identityKeyName: currentUserMasterPubkey))
        .setValue(_latestEventTimestampKey, createdAt);
  }
}

abstract class PersistentSubscriptionEventHandler {
  bool canHandle(EventMessage eventMessage);

  Future<void> handle(EventMessage eventMessage);
}

class PersistentEventDispatcher {
  PersistentEventDispatcher(this.ref, this._handlers);

  final Ref ref;
  final List<PersistentSubscriptionEventHandler> _handlers;

  Future<void> dispatch(EventMessage eventMessage) async {
    for (final handler in _handlers) {
      if (handler.canHandle(eventMessage)) {
        unawaited(handler.handle(eventMessage));
        break;
      }
    }
  }
}

@riverpod
Future<PersistentEventDispatcher> persistentEventDispatcherNotifier(Ref ref) async {
  return PersistentEventDispatcher(ref, [
    // PrivateDirectMessageEventHandler(ref),
    // PrivateMessageReactionEventHandler(ref),
    // GenericRepostEventHandler(ref),
    // DeletionRequestEventHandler(ref),
    await ref.watch(encryptedMessageEventHandlerProvider.future),
  ]);
}
