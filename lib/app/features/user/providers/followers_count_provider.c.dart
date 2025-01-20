// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/relays_provider.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followers_count_provider.c.g.dart';

@Riverpod(keepAlive: true)
class FollowersCount extends _$FollowersCount {
  @override
  Future<int> build(String pubkey) async {
    final followersCountEntity = ref.watch(
      ionConnectCacheProvider.select(
        cacheSelector<EventCountResultEntity>(
          EventCountResultEntity.cacheKeyBuilder(
            key: pubkey,
            type: EventCountResultType.followers,
          ),
        ),
      ),
    );

    if (followersCountEntity != null) {
      final contentMap = followersCountEntity.data.content as Map<String, dynamic>;
      return contentMap[pubkey] as int? ?? 0;
    }

    return _fetchFollowersCount(pubkey);
  }

  Future<int> _fetchFollowersCount(String pubkey) async {
    final relay = await _getRandomUserRelay();

    final requestEvent = await _buildRequestEvent(relayUrl: relay.url);
    final subscriptionMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: const [EventCountResultEntity.kind, 7400],
          tags: {
            '#b': [pubkey],
          },
        ),
      );

    final subscription = relay.subscribe(subscriptionMessage);
    EventMessage? responseMessage;

    try {
      await ref.read(ionConnectNotifierProvider.notifier).sendEvent(
            requestEvent,
            actionSource: ActionSourceRelayUrl(relay.url),
            cache: false,
          );

      responseMessage = await subscription.messages
          .firstWhere((message) => message is EventMessage)
          .timeout(const Duration(seconds: 10)) as EventMessage;

      final eventCountResultEntity = EventCountResultEntity.fromEventMessage(responseMessage);
      ref.read(ionConnectCacheProvider.notifier).cache(eventCountResultEntity);

      final contentMap = eventCountResultEntity.data.content as Map<String, dynamic>;
      return contentMap[pubkey] as int? ?? 0;
    } finally {
      relay.unsubscribe(subscription.id);
    }
  }

  Future<NostrRelay> _getRandomUserRelay() async {
    final userRelays = await ref.read(currentUserRelayProvider.future);
    if (userRelays == null) {
      throw UserRelaysNotFoundException();
    }

    final relayUrl = userRelays.data.list.random.url;
    return await ref.read(relayProvider(relayUrl).future);
  }

  Future<EventMessage> _buildRequestEvent({required String relayUrl}) async {
    final followersCountRequest = EventCountRequestData(
      relays: [relayUrl],
      params: const EventCountRequestParams(group: 'p'),
      filters: [
        RequestFilter(
          kinds: const [FollowListEntity.kind],
          tags: {
            '#p': [pubkey],
          },
        ),
      ],
    );

    return ref.read(ionConnectNotifierProvider.notifier).sign(followersCountRequest);
  }
}
