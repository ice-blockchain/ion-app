// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/providers/global_subscription_event_dispatcher_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/global_subscription_latest_event_timestamp_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/features/user/model/badges/badge_award.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_subscription.c.g.dart';

class GlobalSubscription {
  GlobalSubscription({
    required this.currentUserMasterPubkey,
    required this.devicePubkey,
    required this.latestEventTimestampService,
    required this.ionConnectNotifier,
    required this.globalSubscriptionNotifier,
    required this.globalSubscriptionEventDispatcher,
  });

  final String currentUserMasterPubkey;
  final String devicePubkey;
  final GlobalSubscriptionLatestEventTimestampService latestEventTimestampService;
  final IonConnectNotifier ionConnectNotifier;
  final GlobalSubscriptionNotifier globalSubscriptionNotifier;
  final GlobalSubscriptionEventDispatcher globalSubscriptionEventDispatcher;

  static const List<int> _genericEventKinds = [
    BadgeAwardEntity.kind,
    FollowListEntity.kind,
    ReactionEntity.kind,
    ModifiablePostEntity.kind,
    GenericRepostEntity.modifiablePostRepostKind,
  ];

  static const List<int> _encryptedEventKinds = [IonConnectGiftWrapEntity.kind];

  void init() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final regularLatestEventTimestamp = latestEventTimestampService.get(EventType.regular);

    if (regularLatestEventTimestamp == null) {
      latestEventTimestampService.update(now, EventType.regular);
      _startSubscription();
    } else {
      _reConnectToGlobalSubscription(
        regularLatestEventTimestamp: regularLatestEventTimestamp,
        now: now,
      );
    }
  }

  void _startSubscription() {
    _subscribe(
      eventLimit: 1,
    );
  }

  Future<void> _reConnectToGlobalSubscription({
    required int regularLatestEventTimestamp,
    required int now,
  }) async {
    int? tmpLastCreatedAt;
    while (true) {
      final (maxCreatedAt, stopFetching) = await _fetchPreviousEvents(
        regularSince: tmpLastCreatedAt ?? regularLatestEventTimestamp,
      );
      if (stopFetching) {
        break;
      }
      tmpLastCreatedAt = maxCreatedAt;
    }

    final encryptedLatestEventTimestamp = latestEventTimestampService.get(EventType.encrypted);

    unawaited(
      _subscribe(
        eventLimit: 100,
        regularSince: tmpLastCreatedAt ?? regularLatestEventTimestamp,
        encryptedSince:
            encryptedLatestEventTimestamp ?? now - const Duration(days: 2).inMicroseconds,
      ),
    );
  }

  Future<(int maxCreatedAt, bool stopFetching)> _fetchPreviousEvents({
    int? regularSince,
    int? regularUntil,
    int? previousMaxCreatedAt,
    List<String> previousRegularIds = const [],
    int page = 1,
  }) async {
    try {
      final requestMessage = RequestMessage(
        filters: [
          RequestFilter(
            since: regularSince?.toMicroseconds,
            until: regularUntil?.toMicroseconds,
            limit: 100,
            kinds: _genericEventKinds,
            tags: {
              '#p': [
                [currentUserMasterPubkey],
              ],
            },
          ),
        ],
      );

      final eventsStream = ionConnectNotifier.requestEvents(
        requestMessage,
      );

      var maxCreatedAt = previousMaxCreatedAt ?? 0;
      int? minCreatedAt;
      final regularIds = <String>[];
      await for (final event in eventsStream) {
        final eventCreatedAt = event.createdAt.toMicroseconds;

        if (minCreatedAt == null || eventCreatedAt < minCreatedAt) {
          minCreatedAt = eventCreatedAt;
        }
        if (eventCreatedAt > maxCreatedAt) {
          maxCreatedAt = eventCreatedAt;
        }

        regularIds.add(event.id);
        if (!previousRegularIds.contains(event.id)) {
          await _handleEvent(event);
        }
      }

      final nonDuplicateEventIds = regularIds.whereNot((id) => previousRegularIds.contains(id));

      if (nonDuplicateEventIds.isEmpty) {
        return (maxCreatedAt, page <= 2);
      }

      return _fetchPreviousEvents(
        regularSince: regularSince,
        regularUntil: minCreatedAt,
        previousMaxCreatedAt: maxCreatedAt,
        previousRegularIds: [...previousRegularIds, ...nonDuplicateEventIds],
        page: page + 1,
      );
    } catch (e) {
      throw GlobalSubscriptionSyncEventsException(e);
    }
  }

  Future<void> _subscribe({
    required int eventLimit,
    int? regularSince,
    int? encryptedSince,
  }) async {
    try {
      final requestMessage = RequestMessage(
        filters: [
          RequestFilter(
            kinds: _genericEventKinds,
            tags: {
              '#p': [
                [currentUserMasterPubkey],
              ],
            },
            limit: eventLimit,
            since: regularSince?.toMicroseconds,
          ),
          RequestFilter(
            kinds: _encryptedEventKinds,
            tags: {
              '#p': [
                [currentUserMasterPubkey, '', devicePubkey],
              ],
            },
            since: encryptedSince,
          ),
        ],
      );

      globalSubscriptionNotifier.subscribe(requestMessage, onEvent: _handleEvent);
    } catch (e) {
      throw GlobalSubscriptionSubscribeException(e);
    }
  }

  Future<void> _handleEvent(
    EventMessage eventMessage,
  ) async {
    try {
      final eventType = eventMessage.kind == IonConnectGiftWrapEntity.kind
          ? EventType.encrypted
          : EventType.regular;

      await latestEventTimestampService.update(eventMessage.createdAt.toMicroseconds, eventType);
      globalSubscriptionEventDispatcher.dispatch(eventMessage);
    } catch (e) {
      throw GlobalSubscriptionEventMessageHandlingException(e);
    }
  }
}

@riverpod
class GlobalSubscriptionNotifier extends _$GlobalSubscriptionNotifier {
  @override
  void build() {}

  void subscribe(
    RequestMessage requestMessage, {
    required void Function(EventMessage) onEvent,
  }) {
    final stream = ref.watch(ionConnectEventsSubscriptionProvider(requestMessage));
    final subscription = stream.listen(onEvent);
    ref.onDispose(subscription.cancel);
  }
}

@riverpod
GlobalSubscription? globalSubscription(Ref ref) {
  keepAliveWhenAuthenticated(ref);

  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
  final devicePubkey = ref.watch(currentUserIonConnectEventSignerProvider).valueOrNull?.publicKey;
  final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;

  if (currentUserMasterPubkey == null || devicePubkey == null || !delegationComplete) {
    return null;
  }

  final latestEventTimestampService =
      ref.watch(globalSubscriptionLatestEventTimestampServiceProvider);
  final ionConnectNotifier = ref.watch(ionConnectNotifierProvider.notifier);
  final globalSubscriptionNotifier = ref.watch(globalSubscriptionNotifierProvider.notifier);
  final globalSubscriptionEventDispatcherNotifier =
      ref.watch(globalSubscriptionEventDispatcherNotifierProvider).valueOrNull;

  if (latestEventTimestampService == null || globalSubscriptionEventDispatcherNotifier == null) {
    return null;
  }

  return GlobalSubscription(
    currentUserMasterPubkey: currentUserMasterPubkey,
    devicePubkey: devicePubkey,
    latestEventTimestampService: latestEventTimestampService,
    ionConnectNotifier: ionConnectNotifier,
    globalSubscriptionNotifier: globalSubscriptionNotifier,
    globalSubscriptionEventDispatcher: globalSubscriptionEventDispatcherNotifier,
  );
}
