// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/relays_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_members_count_provider.c.g.dart';

@riverpod
class CommunityMembersCount extends _$CommunityMembersCount {
  @override
  FutureOr<int?> build() async {
    return null;
  }

  Future<void> fetch(CommunityDefinitionEntity community) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // if 6 hours did not passed since community was created, fetch followers count from relay
      const duration = Duration(hours: 6);
      if (community.createdAt.add(duration).isBefore(DateTime.now())) {
        final followersCountEntity = ref.read(
          ionConnectCacheProvider.select(
            cacheSelector<EventCountResultEntity>(
              EventCountResultEntity.cacheKeyBuilder(
                key: community.data.uuid,
                type: EventCountResultType.members,
              ),
            ),
          ),
        );

        if (followersCountEntity != null) {
          return followersCountEntity.data.content as int;
        }
      }

      final relay = await _getOwnerRandomUserRelay(community);

      final requestEvent = await _buildRequestEvent(
        relayUrl: relay.url,
        communityUUID: community.data.uuid,
      );
      final subscriptionMessage = RequestMessage()
        ..addFilter(
          RequestFilter(
            kinds: const [EventCountResultEntity.kind],
            tags: {
              '#h': [community.data.uuid],
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

        final eventCountResultEntity =
            EventCountResultEntity.fromEventMessage(responseMessage, key: community.data.uuid);
        ref.read(ionConnectCacheProvider.notifier).cache(eventCountResultEntity);

        return eventCountResultEntity.data.content as int;
      } finally {
        relay.unsubscribe(subscription.id);
      }
    });
  }

  Future<NostrRelay> _getOwnerRandomUserRelay(CommunityDefinitionEntity community) async {
    final userRelays = await ref.read(userRelayProvider(community.ownerPubkey).future);
    if (userRelays == null) {
      throw UserRelaysNotFoundException();
    }

    final relayUrl = userRelays.data.list.random.url;
    return await ref.read(relayProvider(relayUrl).future);
  }

  Future<EventMessage> _buildRequestEvent({
    required String relayUrl,
    required String communityUUID,
  }) async {
    final communityMembersCountRequest = EventCountRequestData(
      params: EventCountRequestParams(
        relay: relayUrl,
      ),
      filters: [
        RequestFilter(
          kinds: const [CommunityJoinEntity.kind],
          tags: {
            '#h': [communityUUID],
          },
        ),
      ],
    );

    return ref.read(ionConnectNotifierProvider.notifier).sign(communityMembersCountRequest);
  }
}
