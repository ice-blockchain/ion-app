// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/community/providers/community_join_requests_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/logger/logger.dart';
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

    final latestEventMessageDate = await ref
        .watch(conversationEventMessageDaoProvider)
        .getLatestEventMessageDate(ModifiablePostEntity.kind);

    final sinceDate = latestEventMessageDate?.add(const Duration(days: -2));

    for (final communityId in communityIds) {
      await _fetchCommunityMessages(communityId, sinceDate);
    }

    yield null;
  }

  Future<void> _fetchCommunityMessages(String communityId, DateTime? sinceDate) async {
    final ownerPubkey = await ref
        .watch(communityMetadataProvider(communityId).selectAsync((data) => data.ownerPubkey));

    final requestFilter = RequestFilter(
      kinds: const [ModifiablePostEntity.kind],
      tags: {
        '#h': [communityId],
      },
      since: sinceDate,
    );

    final requestMessage = RequestMessage()..addFilter(requestFilter);

    ref.watch(ionConnectNotifierProvider.notifier).requestEvents(
      requestMessage,
      actionSource: ActionSourceUser(ownerPubkey),
      subscriptionBuilder: (requestMessage, relay) {
        final subscription = relay.subscribe(requestMessage);
        ref.onDispose(() {
          try {
            relay.unsubscribe(subscription.id);
          } catch (error, stackTrace) {
            Logger.log('Failed to unsubscribe', error: error, stackTrace: stackTrace);
          }
        });
        return subscription.messages;
      },
    ).listen((event) {
      if (event.kind == ModifiablePostEntity.kind) {
        ref.watch(conversationEventMessageDaoProvider).add(event);
      }
    });
  }
}
