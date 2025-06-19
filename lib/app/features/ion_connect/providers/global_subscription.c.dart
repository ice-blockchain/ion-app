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
    final regularLatestEventTimestamp = latestEventTimestampService.get(EventType.regular);

    if (regularLatestEventTimestamp == null) {
      _startSubscription();
    } else {
      _reConnectToGlobalSubscription(
        regularLatestEventTimestamp: regularLatestEventTimestamp,
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
  }) async {
    final now = DateTime.now().microsecondsSinceEpoch;
    final regularCreatedAts = await _fetchPreviousEvents(
      regularSince: regularLatestEventTimestamp,
    );
    var mostRecentRegularEventTimestamp = regularCreatedAts.maxOrNull;

    if (mostRecentRegularEventTimestamp != null) {
      final missingRegularCreatedAts = await _fetchPreviousEvents(
        regularSince: mostRecentRegularEventTimestamp,
        isRecursive: false,
      );
      mostRecentRegularEventTimestamp = missingRegularCreatedAts.maxOrNull;
    }

    final encryptedLatestEventTimestamp = latestEventTimestampService.get(EventType.encrypted);

    unawaited(
      _subscribe(
        eventLimit: 100,
        regularSince: mostRecentRegularEventTimestamp ?? now,
        encryptedSince:
            encryptedLatestEventTimestamp ?? now - const Duration(days: 2).inMicroseconds,
      ),
    );
  }

  Future<List<int>> _fetchPreviousEvents({
    int? regularSince,
    int? regularUntil,
    List<int> previousRegularCreatedAts = const [],
    List<String> previousRegularIds = const [],
    bool isRecursive = true,
  }) async {
    try {
      final requestMessage = RequestMessage(
        filters: [
          RequestFilter(
            kinds: _genericEventKinds,
            since: regularSince?.toMicroseconds,
            until: regularUntil?.toMicroseconds,
            tags: {
              '#p': [
                [currentUserMasterPubkey],
              ],
            },
          ),
        ],
      );

      print('GLOBAL SUBSCRIPTION - FETCH PREVIOUS EVENTS FILTERS: ${requestMessage.filters}');

      final eventsStream = ionConnectNotifier.requestEvents(
        requestMessage,
      );

      final regularCreatedAts = <int>[];
      final regularIds = <String>[];
      var count = 0;
      await for (final event in eventsStream) {
        if (previousRegularIds.contains(event.id)) {
          continue;
        }
        regularIds.add(event.id);
        regularCreatedAts.add(event.createdAt.toMicroseconds);

        await _handleEvent(event);
        count++;
      }

      final allRegularCreatedAts = [...previousRegularCreatedAts, ...regularCreatedAts];

      if (count == 0 || !isRecursive) {
        return allRegularCreatedAts;
      }

      return _fetchPreviousEvents(
        regularSince: regularSince,
        regularUntil: regularCreatedAts.min,
        previousRegularCreatedAts: allRegularCreatedAts,
        previousRegularIds: regularIds,
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

      print('GLOBAL SUBSCRIPTION - FILTERS: ${requestMessage.filters}');
      print('GLOBAL SUBSCRIPTION - master pubkey: $currentUserMasterPubkey');
      print('GLOBAL SUBSCRIPTION - device pubkey: $devicePubkey');

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

      print('GLOBAL SUBSCRIPTION - EVENT: ${eventMessage.id} ${eventMessage.kind}');

      await latestEventTimestampService.update(eventMessage.createdAt.toMicroseconds, eventType);
      await globalSubscriptionEventDispatcher.dispatch(eventMessage);
    } catch (e) {
      throw GlobalSubscriptionEventMessageHandlingException(e);
    }
  }
}

@riverpod
class GlobalSubscriptionNotifier extends _$GlobalSubscriptionNotifier {
  @override
  void build() {
    return;
  }

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
  final devicePubkey = ref.read(currentUserIonConnectEventSignerProvider).valueOrNull?.publicKey;
  final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;
  final latestEventTimestampService =
      ref.watch(globalSubscriptionLatestEventTimestampServiceProvider);
  final ionConnectNotifier = ref.watch(ionConnectNotifierProvider.notifier);
  final globalSubscriptionNotifier = ref.watch(globalSubscriptionNotifierProvider.notifier);
  final globalSubscriptionEventDispatcherNotifier =
      ref.watch(globalSubscriptionEventDispatcherNotifierProvider).valueOrNull;

  if (currentUserMasterPubkey == null ||
      devicePubkey == null ||
      !delegationComplete ||
      latestEventTimestampService == null ||
      globalSubscriptionEventDispatcherNotifier == null) {
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
