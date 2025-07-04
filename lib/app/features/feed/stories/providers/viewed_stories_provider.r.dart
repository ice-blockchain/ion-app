// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/repository/following_feed_seen_events_repository.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'viewed_stories_provider.r.g.dart';

@Riverpod(keepAlive: true)
class ViewedStoriesController extends _$ViewedStoriesController {
  @override
  Set<EventReference> build() {
    final seenEventsRepository = ref.watch(followingFeedSeenEventsRepositoryProvider);
    seenEventsRepository.getEventReferences(
      feedType: FeedType.story,
      exclude: [],
    ).then((seenEvents) => state = seenEvents.map((e) => e.eventReference).toSet());

    return {};
  }

  Future<void> markStoryAsViewed(IonConnectEntity storyEntity) async {
    final storyReference = storyEntity.toEventReference();
    if (!state.contains(storyReference)) {
      final updated = {...state, storyReference};
      state = updated;

      final seenEventsRepository = ref.read(followingFeedSeenEventsRepositoryProvider);
      await seenEventsRepository.save(storyEntity, feedType: FeedType.story);
    }
  }
}
