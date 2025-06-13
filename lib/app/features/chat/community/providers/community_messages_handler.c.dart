// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_messages_handler.c.g.dart';

// TODO: Remove this once we will enable community messages
// we have to handle community messages on global long running subscription
@Riverpod(keepAlive: true)
class CommunityMessagesSubscriber extends _$CommunityMessagesSubscriber {
  @override
  Stream<void> build() async* {
    final hideCommunity =
        ref.watch(featureFlagsProvider.notifier).get(ChatFeatureFlag.hideCommunity);

    if (hideCommunity) {
      yield null;
    }
    // final joinedCommunities = await ref.watch(communityJoinRequestsProvider.future);

    // final communityIds = joinedCommunities.accepted.map((e) => e.data.uuid).toList();

    // for (final communityId in communityIds) {
    //   await _fetchCommunityMessages(communityId);
    // }

    yield null;
  }

  // Future<void> _fetchCommunityMessages(String communityId) async {
  //   //TODO: Remove this once we will enable community messages
  //   // we have to handle community messages on global long running subscription
  //   final ownerPubkey = await ref
  //       .watch(communityMetadataProvider(communityId).selectAsync((data) => data.ownerPubkey));

  //   final requestFilter = RequestFilter(
  //     kinds: const [ModifiablePostEntity.kind],
  //     tags: {
  //       '#h': [communityId],
  //     },
  //   );

  //   final latestEventMessageDate = await ref
  //       .watch(conversationEventMessageDaoProvider)
  //       .getLatestEventMessageDate([ModifiablePostEntity.kind]);

  //   final latestSyncedEventTimestamp = await ref.watch(eventSyncerServiceProvider).syncEvents(
  //     requestFilters: [requestFilter],
  //     sinceDateMicroseconds: latestEventMessageDate?.microsecondsSinceEpoch,
  //     saveCallback: (eventMessage) {
  //       if (eventMessage.kind == ModifiablePostEntity.kind) {
  //         ref.read(conversationEventMessageDaoProvider).add(eventMessage);
  //       }
  //     },
  //     overlap: const Duration(days: 2),
  //     actionSource: ActionSourceUser(ownerPubkey),
  //   );

  //   final requestMessage = RequestMessage()
  //     ..addFilter(
  //       requestFilter.copyWith(
  //         since: () => latestSyncedEventTimestamp,
  //       ),
  //     );

  //   final events = ref.watch(
  //     ionConnectEventsSubscriptionProvider(
  //       requestMessage,
  //       actionSource: ActionSourceUser(ownerPubkey),
  //     ),
  //   );

  //   final subscription = events
  //       .where((event) => event.kind == ModifiablePostEntity.kind)
  //       .listen(ref.read(conversationEventMessageDaoProvider).add);

  //   ref.onDispose(subscription.cancel);
  // }
}
