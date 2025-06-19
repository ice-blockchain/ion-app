// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
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
import 'package:ion/app/features/user/model/badges/profile_badges.c.dart';
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

  static const List<int> _authorBasedEventKinds = [
    BookmarksSetEntity.kind,
    BookmarksEntity.kind,
    ProfileBadgesEntity.kind,
  ];

  static const List<int> _encryptedEventKinds = [IonConnectGiftWrapEntity.kind];

  Future<void> init() async {
    final regularLatestEventTimestamp = latestEventTimestampService.get(EventType.regular);
    final authorBasedLatestEventTimestamp = latestEventTimestampService.get(EventType.authorBased);

    if (regularLatestEventTimestamp == null || authorBasedLatestEventTimestamp == null || true) {
      _startSubscription();
    } else {
      unawaited(
        _reConnectToGlobalSubscription(
          regularLatestEventTimestamp: regularLatestEventTimestamp,
          authorBasedLatestEventTimestamp: authorBasedLatestEventTimestamp,
        ),
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
    required int authorBasedLatestEventTimestamp,
  }) async {
    final now = DateTime.now().microsecondsSinceEpoch;
    final (regularCreatedAts, authorBasedCreatedAts) = await _fetchPreviousEvents(
      regularSince: regularLatestEventTimestamp,
      authorBasedSince: authorBasedLatestEventTimestamp,
    );
    var mostRecentRegularEventTimestamp = regularCreatedAts.maxOrNull;
    var mostRecentAuthorBasedEventTimestamp = authorBasedCreatedAts.maxOrNull;

    if (mostRecentRegularEventTimestamp != null) {
      final (missingRegularCreatedAts, missingAuthorBasedCreatedAts) = await _fetchPreviousEvents(
        regularSince: mostRecentRegularEventTimestamp,
        authorBasedSince: mostRecentAuthorBasedEventTimestamp,
        isRecursive: false,
      );
      mostRecentRegularEventTimestamp = missingRegularCreatedAts.maxOrNull;
      mostRecentAuthorBasedEventTimestamp = missingAuthorBasedCreatedAts.maxOrNull;
    }

    final encryptedLatestEventTimestamp = latestEventTimestampService.get(EventType.encrypted);

    unawaited(
      _subscribe(
        eventLimit: 100,
        regularSince: mostRecentRegularEventTimestamp ?? now,
        authorBasedSince: mostRecentAuthorBasedEventTimestamp ?? now,
        encryptedSince:
            encryptedLatestEventTimestamp ?? now - const Duration(days: 2).inMicroseconds,
      ),
    );
  }

  Future<(List<int> regularCreatedAts, List<int> authorBasedCreatedAts)> _fetchPreviousEvents({
    int? regularSince,
    int? regularUntil,
    int? authorBasedSince,
    int? authorBasedUntil,
    List<int> previousRegularCreatedAts = const [],
    List<String> previousRegularIds = const [],
    List<int> previousAuthorBasedCreatedAts = const [],
    List<String> previousAuthorBasedIds = const [],
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
          RequestFilter(
            kinds: _authorBasedEventKinds,
            authors: [currentUserMasterPubkey],
            since: authorBasedSince?.toMicroseconds,
            until: authorBasedUntil?.toMicroseconds,
          ),
        ],
      );

      print('GLOBAL SUBSCRIPTION - FETCH PREVIOUS EVENTS FILTERS: ${requestMessage.filters}');

      final eventsStream = ionConnectNotifier.requestEvents(
        requestMessage,
      );

      final regularCreatedAts = <int>[];
      final regularIds = <String>[];
      final authorBasedCreatedAts = <int>[];
      final authorBasedIds = <String>[];
      var count = 0;
      await for (final event in eventsStream) {
        if (_authorBasedEventKinds.contains(event.kind)) {
          if (previousAuthorBasedIds.contains(event.id)) {
            continue;
          }
          authorBasedIds.add(event.id);
          authorBasedCreatedAts.add(event.createdAt.toMicroseconds);
        } else {
          if (previousRegularIds.contains(event.id)) {
            continue;
          }
          regularIds.add(event.id);
          regularCreatedAts.add(event.createdAt.toMicroseconds);
        }

        await _handleEvent(event);
        count++;
      }

      final allRegularCreatedAts = [...previousRegularCreatedAts, ...regularCreatedAts];
      final allAuthorBasedCreatedAts = [...previousAuthorBasedCreatedAts, ...authorBasedCreatedAts];

      if (count == 0 || !isRecursive) {
        return (allRegularCreatedAts, allAuthorBasedCreatedAts);
      }

      return _fetchPreviousEvents(
        regularSince: regularSince,
        authorBasedSince: authorBasedSince,
        regularUntil: regularCreatedAts.min,
        authorBasedUntil: authorBasedCreatedAts.min,
        previousRegularCreatedAts: allRegularCreatedAts,
        previousAuthorBasedCreatedAts: allAuthorBasedCreatedAts,
        previousRegularIds: regularIds,
        previousAuthorBasedIds: authorBasedIds,
      );
    } catch (e) {
      throw GlobalSubscriptionSyncEventsException(e);
    }
  }

  Future<void> _subscribe({
    required int eventLimit,
    int? regularSince,
    int? authorBasedSince,
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
            kinds: _authorBasedEventKinds,
            authors: [currentUserMasterPubkey],
            since: authorBasedSince?.toMicroseconds,
            limit: eventLimit,
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
          : _authorBasedEventKinds.contains(eventMessage.kind)
              ? EventType.authorBased
              : EventType.regular;

      if (eventType == EventType.encrypted) {
        // print('GLOBAL SUBSCRIPTION - ENCRYPTED EVENT: ${eventMessage.id}');
      }

      if (_authorBasedEventKinds.contains(eventMessage.kind)) {
        print('GLOBAL SUBSCRIPTION - BOOKMARKS EVENT: ${eventMessage.id}');
      }

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
    // print('GLOBAL SUBSCRIPTION - SUBSCRIBE');
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
