// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/community/providers/community_join_requests_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat/providers/dao/conversation_event_message_dao_provider.c.dart';
import 'package:ion/app/features/core/data/models/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/data/models/action_source.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/entities_syncer_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_messages_subscriber_provider.c.g.dart';

@Riverpod(keepAlive: true)
class CommunityMessagesSubscriber extends _$CommunityMessagesSubscriber {
  @override
  Stream<void> build() async* {
    final hideCommunity =
        ref.watch(featureFlagsProvider.notifier).get(ChatFeatureFlag.hideCommunity);

    if (hideCommunity) {
      yield null;
    }

    final joinedCommunities = await ref.watch(communityJoinRequestsProvider.future);

    final communityIds = joinedCommunities.accepted.map((e) => e.data.uuid).toList();

    for (final communityId in communityIds) {
      await _fetchCommunityMessages(communityId);
    }

    yield null;
  }

  Future<void> _fetchCommunityMessages(String communityId) async {
    final ownerPubkey = await ref
        .watch(communityMetadataProvider(communityId).selectAsync((data) => data.ownerPubkey));

    final requestFilter = RequestFilter(
      kinds: const [ModifiablePostEntity.kind],
      tags: {
        '#h': [communityId],
      },
      since: DateTime.now().subtract(const Duration(days: 2)).microsecondsSinceEpoch,
    );

    await ref.watch(entitiesSyncerNotifierProvider('community-messages').notifier).syncEvents(
      requestFilters: [requestFilter],
      saveCallback: (eventMessage) {
        if (eventMessage.kind == ModifiablePostEntity.kind) {
          ref.read(conversationEventMessageDaoProvider).add(eventMessage);
        }
      },
      maxCreatedAtBuilder: () => ref
          .watch(conversationEventMessageDaoProvider)
          .getLatestEventMessageDate([ModifiablePostEntity.kind]),
      minCreatedAtBuilder: (since) => ref
          .watch(conversationEventMessageDaoProvider)
          .getEarliestEventMessageDate([ModifiablePostEntity.kind], after: since),
      overlap: const Duration(days: 2),
      actionSource: ActionSourceUser(ownerPubkey),
    );

    final requestMessage = RequestMessage()..addFilter(requestFilter);

    final events = ref.watch(
      ionConnectEventsSubscriptionProvider(
        requestMessage,
        actionSource: ActionSourceUser(ownerPubkey),
      ),
    );

    final subscription = events
        .where((event) => event.kind == ModifiablePostEntity.kind)
        .listen(ref.read(conversationEventMessageDaoProvider).add);

    ref.onDispose(subscription.cancel);
  }
}
