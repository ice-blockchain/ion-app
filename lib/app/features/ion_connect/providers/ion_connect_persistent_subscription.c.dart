// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/persistent_subscription_event_dispatcher_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/persistent_subscription_latest_event_timestamp_provider.c.dart';
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
      since: latestEventTimestamp,
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
      throw PersistentSubscriptionSyncEventsException(e);
    }
  }

  Future<void> _subscribe() async {
    final latestEventTimestamp = ref.watch(persistentSubscriptionLatestEventTimestampProvider);
    final requestMessage = await _requestMessageBuilder(
      since: latestEventTimestamp,
    );
    // //TODO: Remove this once we have a proper way to handle gift wrap events on relay
    // requestMessage.filters[1] = requestMessage.filters[1]
    //     .copyWith(since: () => DateTime.now().microsecondsSinceEpoch.overlap);
    final stream = ref.watch(ionConnectEventsSubscriptionProvider(requestMessage));
    final subscription = stream.listen(_handleEvent);
    ref.onDispose(subscription.cancel);
  }

  Future<void> _handleEvent(
    EventMessage eventMessage,
  ) async {
    try {
      final dispatcher =
          await ref.watch(persistentSubscriptionEventDispatcherNotifierProvider.future);
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

    //TODO: uncomment this once we have a proper way to handle gift wrap events on relay
    // final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);
    // if (eventSigner == null) {
    //   throw EventSignerNotFoundException();
    // }
    // final currentUserDeviceKey = eventSigner.publicKey;

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
        //TODO: uncomment this once we have a proper way to handle gift wrap events on relay
        // RequestFilter(
        //   kinds: const [IonConnectGiftWrapEntity.kind],
        //   tags: {
        //     '#p': [
        //       [currentUserMasterPubkey, '', currentUserDeviceKey],
        //     ],
        //   },
        //   since: since?.overlap,
        //   until: until,
        //   limit: 50,
        // ),
      ],
    );
  }
}
