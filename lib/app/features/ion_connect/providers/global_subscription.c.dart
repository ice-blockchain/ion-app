// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_collection.c.dart';
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
import 'package:ion/app/features/user/model/badges/badge_definition.c.dart';
import 'package:ion/app/features/user/model/badges/profile_badges.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_subscription.c.g.dart';

@riverpod
class GlobalSubscription extends _$GlobalSubscription {
  static const List<int> _genericEventKinds = [
    BookmarksCollectionEntity.kind, // no p tag and need to test
    BookmarksEntity.kind, // has p tag
    ProfileBadgesEntity.kind, // no p tag and need to test
    BadgeDefinitionEntity.kind, // no p tag and need to test
    BadgeAwardEntity.kind, // has p tag and need to test
    FollowListEntity.kind, // has p tag
    ReactionEntity.kind, // has p tag
    ModifiablePostEntity.kind, // has p tag
    GenericRepostEntity.kind, // has p tag
  ];

  static const List<int> _encryptedEventKinds = [IonConnectGiftWrapEntity.kind];

  @override
  Future<void> build() async {
    keepAliveWhenAuthenticated(ref);

    final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;
    if (!delegationComplete) return;

    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      return;
    }

    final regularLatestEventTimestamp =
        ref.read(globalSubscriptionLatestEventTimestampProvider(EventType.regular));

    if (regularLatestEventTimestamp == null) {
      _startSubscription();
    } else {
      unawaited(
        _reConnectToGlobalSubscription(
          regularLatestEventTimestamp: regularLatestEventTimestamp,
        ),
      );
    }
  }

  void _startSubscription() {
    _subscribe(
      regularEventLimit: 1,
    );
  }

  Future<void> _reConnectToGlobalSubscription({
    required int regularLatestEventTimestamp,
  }) async {
    final now = DateTime.now().microsecondsSinceEpoch;
    final createdAts = await _fetchPreviousEvents(since: regularLatestEventTimestamp);
    var mostRecentEventTimestamp = createdAts.maxOrNull;

    if (mostRecentEventTimestamp != null) {
      final missingEventsCreatedAts = await _fetchPreviousEvents(
        since: mostRecentEventTimestamp,
        isRecursive: false,
      );
      mostRecentEventTimestamp = missingEventsCreatedAts.maxOrNull;
    }

    final encryptedLatestEventTimestamp =
        ref.read(globalSubscriptionLatestEventTimestampProvider(EventType.encrypted));

    unawaited(
      _subscribe(
        regularEventLimit: 100,
        regularSince: mostRecentEventTimestamp ?? now,
        encryptedSince:
            encryptedLatestEventTimestamp ?? now - const Duration(days: 2).inMicroseconds,
      ),
    );
  }

  Future<List<int>> _fetchPreviousEvents({
    int? since,
    int? until,
    List<int> previousCreatedAts = const [],
    List<String> previousIds = const [],
    bool isRecursive = true,
  }) async {
    try {
      final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
      if (currentUserMasterPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final requestMessage = RequestMessage(
        filters: [
          RequestFilter(
            kinds: _genericEventKinds,
            limit: 100,
            since: since,
            until: until,
            tags: {
              '#p': [
                [currentUserMasterPubkey],
              ],
            },
          ),
        ],
      );

      final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);
      final eventsStream = ionConnectNotifier.requestEvents(
        requestMessage,
      );

      final createdAts = <int>[];
      final ids = <String>[];
      var count = 0;
      await for (final event in eventsStream) {
        if (previousIds.contains(event.id)) {
          continue;
        }

        createdAts.add(event.createdAt.toMicroseconds);
        ids.add(event.id);

        await _handleEvent(event);
        count++;
      }

      final allCreatedAts = [...previousCreatedAts, ...createdAts];

      if (count == 0 || !isRecursive) {
        return allCreatedAts;
      }

      return _fetchPreviousEvents(
        since: since,
        until: createdAts.min,
        previousCreatedAts: allCreatedAts,
        previousIds: ids,
      );
    } catch (e) {
      throw GlobalSubscriptionSyncEventsException(e);
    }
  }

  Future<void> _subscribe({
    required int regularEventLimit,
    int? regularSince,
    int? encryptedSince,
  }) async {
    try {
      final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
      if (currentUserMasterPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final devicePubkey =
          ref.read(currentUserIonConnectEventSignerProvider).valueOrNull?.publicKey;

      if (devicePubkey == null) {
        throw EventSignerNotFoundException();
      }

      final requestMessage = RequestMessage(
        filters: [
          RequestFilter(
            kinds: _genericEventKinds,
            tags: {
              '#p': [
                [currentUserMasterPubkey],
              ],
            },
            limit: regularEventLimit,
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

      final stream = ref.watch(ionConnectEventsSubscriptionProvider(requestMessage));
      final subscription = stream.listen(_handleEvent);
      ref.onDispose(subscription.cancel);
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

      await ref
          .read(globalSubscriptionLatestEventTimestampProvider(eventType).notifier)
          .update(eventMessage.createdAt.toMicroseconds);

      final dispatcher = await ref.watch(globalSubscriptionEventDispatcherNotifierProvider.future);
      await dispatcher.dispatch(eventMessage);
    } catch (e) {
      throw GlobalSubscriptionEventMessageHandlingException(e);
    }
  }
}
