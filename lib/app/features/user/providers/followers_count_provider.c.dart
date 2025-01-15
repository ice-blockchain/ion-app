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
  Future<int?> build(String pubkey) async {
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
      return followersCountEntity.data.content as int;
    }

    final relay = await _getRandomUserRelay();

    final requestEvent = await _buildRequestEvent(relayUrl: relay.url);

    final subscriptionMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: const [EventCountResultEntity.kind],
          e: [requestEvent.id],
          limit: 1,
        ),
      );

    // We first subscribe to the count response
    final subscription = relay.subscribe(subscriptionMessage);

    // Then send the request event
    await ref.watch(ionConnectNotifierProvider.notifier).sendEvent(
          requestEvent,
          actionSource: ActionSourceRelayUrl(relay.url),
          cache: false,
        );

    // Waiting for the response
    final responseMessage =
        await subscription.messages.firstWhere((message) => message is EventMessage);

    // And unsubscribe
    relay.unsubscribe(subscription.id);

    //TODO::currently it fails on parsing
    // 1. BE should add `b` tag to the event
    // 2. The content is `{}`, so either request params are wrong or BE calculates it incorrectly
    final eventCountResultEntity =
        EventCountResultEntity.fromEventMessage(responseMessage as EventMessage);

    ref.watch(ionConnectCacheProvider.notifier).cache(eventCountResultEntity);

    return eventCountResultEntity.data.content as int?;
  }

  Future<NostrRelay> _getRandomUserRelay() async {
    final userRelays = await ref.watch(currentUserRelayProvider.future);
    if (userRelays == null) {
      throw UserRelaysNotFoundException();
    }

    final relayUrl = userRelays.data.list.random.url;

    return await ref.watch(relayProvider(relayUrl).future);
  }

  Future<EventMessage> _buildRequestEvent({required String relayUrl}) async {
    final followersCountRequest = EventCountRequestData(
      relays: [relayUrl],
      params: const EventCountRequestParams(group: 'p'),
      filters: [
        RequestFilter(kinds: const [FollowListEntity.kind], p: [pubkey]),
      ],
    );

    return ref.watch(ionConnectNotifierProvider.notifier).sign(followersCountRequest);
  }
}
