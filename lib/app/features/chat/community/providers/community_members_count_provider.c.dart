// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.c.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
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
  Future<int> build(CommunityDefinitionEntity community) async {
    final communityMembersCountEntity = ref.watch(
      ionConnectCacheProvider.select((cache) {
        final key = EventCountResultEntity.cacheKeyBuilder(
          key: community.data.uuid,
          type: EventCountResultType.members,
        );
        return cache[key]?.entity as EventCountResultEntity?;
      }),
    );

    if (communityMembersCountEntity != null) {
      return communityMembersCountEntity.data.content as int;
    }

    return _fetchCommunityMembersCount(community.data.uuid);
  }

  Future<int> _fetchCommunityMembersCount(String communityUUID) async {
    final relay = await _getOwnerRandomUserRelay(communityUUID);

    final requestEvent =
        await _buildRequestEvent(relayUrl: relay.url, communityUUID: communityUUID);
    final subscriptionMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: const [EventCountResultEntity.kind],
          tags: {
            '#h': [communityUUID],
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
          EventCountResultEntity.fromEventMessage(responseMessage, key: communityUUID);
      ref.read(ionConnectCacheProvider.notifier).cache(eventCountResultEntity);

      return eventCountResultEntity.data.content as int;
    } catch (e) {
      return 0;
    } finally {
      relay.unsubscribe(subscription.id);
    }
  }

  Future<NostrRelay> _getOwnerRandomUserRelay(String communityUUID) async {
    final community = await ref.read(communityMetadataProvider(communityUUID).future);
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
