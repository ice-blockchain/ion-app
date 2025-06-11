// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/gift_unwrap_service_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'ion_connect_long_running_subscription_notifier.c.g.dart';

@Riverpod(keepAlive: true)
class IonConnectLongRunningSubscriptionNotifier
    extends _$IonConnectLongRunningSubscriptionNotifier {
  static const _latestSyncedEventCreatedAtTimestampKey =
      'ion_connect_long_running_subscription_latest_synced_event_created_at_timestamp1';

  RequestFilter allEventsFilter(String currentUserMasterPubkey, {int? since, int? until}) =>
      RequestFilter(
        tags: {
          '#p': [
            [currentUserMasterPubkey],
          ],
        },
        since: since,
        until: until,
      );

  RequestFilter encryptedEventsFilter(
    String currentUserMasterPubkey,
    String currentUserDeviceKey, {
    int? since,
    int? until,
  }) =>
      RequestFilter(
        kinds: const [IonConnectGiftWrapEntity.kind],
        tags: {
          '#p': [
            [currentUserMasterPubkey, '', currentUserDeviceKey],
          ],
        },
        since: since,
        until: until,
      );

  @override
  Stream<void> build() async* {
    final authState = await ref.watch(authProvider.future);
    if (!authState.isAuthenticated) return;

    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);
    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }
    final currentUserDeviceKey = eventSigner.publicKey;

    final latestSyncedEventCreatedAtTimestamp = ref
        .watch(userPreferencesServiceProvider(identityKeyName: currentUserMasterPubkey))
        .getValue<int>(_latestSyncedEventCreatedAtTimestampKey);

    await _fetchPreviousEvents(
      currentUserMasterPubkey,
      currentUserDeviceKey,
      null,
      null,
    );
    return;
    //INIT LONG RUNNING SUBSCRIPTION

    final requestMessage = RequestMessage(
      filters: [
        allEventsFilter(currentUserMasterPubkey, since: latestSyncedEventCreatedAtTimestamp),
        encryptedEventsFilter(
          currentUserMasterPubkey,
          currentUserDeviceKey,
          since: latestSyncedEventCreatedAtTimestamp,
        ),
      ],
    );

    final stream = ref.watch(
      ionConnectEventsSubscriptionProvider(
        requestMessage,
      ),
    );

    final subscription = stream.listen(
      _handleMessage,
    );

    ref.onDispose(subscription.cancel);

    yield null;
  }

  Future<void> _fetchPreviousEvents(
    String currentUserMasterPubkey,
    String currentUserDeviceKey,
    int? since,
    int? until,
  ) async {
    try {
      final request = RequestMessage(
        filters: [
          allEventsFilter(
            currentUserMasterPubkey,
            since: since,
            until: until,
          ),
          encryptedEventsFilter(
            currentUserMasterPubkey,
            currentUserDeviceKey,
            since: since.overlap,
            until: until,
          ),
        ],
      );
      print('-------------------------------- long-running-subscription');
      print('--------------------------------- long-running-subscription');
      print('-------------------------------- long-running-subscription');
      print('filters: ${request.filters} long-running-subscription');
      print(
        'since: $since Date: ${since?.toDateTime.toIso8601String()} long-running-subscription',
      );
      print(
        'until: $until Date: ${until?.toDateTime.toIso8601String()} long-running-subscription',
      );
      final ionConnectNotifier = ref.watch(ionConnectNotifierProvider.notifier);
      final eventsStream = ionConnectNotifier.requestEvents(
        request,
      );

      var count = 0;
      int? recentEventCreatedAt;
      int? oldestEventCreatedAt;
      await for (final event in eventsStream) {
        await _handleMessage(event);
        count++;
        final eventCreatedAt = event.createdAt.toMicroseconds;

        if (recentEventCreatedAt == null || eventCreatedAt > recentEventCreatedAt) {
          recentEventCreatedAt = eventCreatedAt;
        }

        if (oldestEventCreatedAt == null || eventCreatedAt < oldestEventCreatedAt) {
          oldestEventCreatedAt = eventCreatedAt;
        }
      }

      print(
        'recentEventCreatedAt: $recentEventCreatedAt Date: ${recentEventCreatedAt?.toDateTime.toIso8601String()} long-running-subscription',
      );
      print(
        'oldestEventCreatedAt: $oldestEventCreatedAt Date: ${oldestEventCreatedAt?.toDateTime.toIso8601String()} long-running-subscription',
      );
      print('count: $count long-running-subscription');

      if (recentEventCreatedAt != null) {
        await _updateLatestSyncedEventCreatedAtTimestamp(recentEventCreatedAt);
      }

      //TODO: handle 0 events
      if (count == 0) {
        return;
      }

      return _fetchPreviousEvents(
        currentUserMasterPubkey,
        currentUserDeviceKey,
        null,
        oldestEventCreatedAt == null ? null : oldestEventCreatedAt - 1,
      );
    } catch (e) {
      print('error: $e long-running-subscription');
    }
  }

  Future<int> _handleMessage(
    EventMessage eventMessage,
  ) async {
    print(
      'Id: ${eventMessage.id} createdAt: ${eventMessage.createdAt} Date: ${eventMessage.createdAt.toDateTime.toIso8601String()} kind: ${eventMessage.kind} long-running-subscription',
    );
    return eventMessage.createdAt;
    if (eventMessage.kind == IonConnectGiftWrapEntity.kind) {
      final giftUnwrapService = await ref.watch(giftUnwrapServiceProvider.future);
      final rumor = await giftUnwrapService.unwrap(eventMessage);

      print(
        'Id: ${rumor.id} createdAt: ${rumor.createdAt} Date: ${rumor.createdAt.toDateTime.toIso8601String()} kind: ${rumor.kind} content: ${rumor.content} long-running-subscription',
      );

      return rumor.createdAt;
    }

    print(
      'Id: ${eventMessage.id} createdAt: ${eventMessage.createdAt} Date: ${eventMessage.createdAt.toDateTime.toIso8601String()} kind: ${eventMessage.kind} content: ${eventMessage.content} long-running-subscription',
    );

    Logger.talker?.log(eventMessage.toString(), logLevel: LogLevel.critical);
    return eventMessage.createdAt;
  }

  Future<void> _updateLatestSyncedEventCreatedAtTimestamp(
    int createdAt,
  ) async {
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final latestSyncedEventCreatedAtTimestamp = ref
        .watch(userPreferencesServiceProvider(identityKeyName: currentUserMasterPubkey))
        .getValue<int>(_latestSyncedEventCreatedAtTimestampKey);
    if (createdAt >= (latestSyncedEventCreatedAtTimestamp ?? 0)) {
      await ref
          .watch(userPreferencesServiceProvider(identityKeyName: currentUserMasterPubkey))
          .setValue(_latestSyncedEventCreatedAtTimestampKey, createdAt + 2);
    }
    return;
  }
}

extension OverlapExtension on int? {
  int? get overlap {
    if (this == null) {
      return null;
    }
    return this! - const Duration(days: 2).inMicroseconds;
  }
}
