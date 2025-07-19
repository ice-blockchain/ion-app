// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_sync_strategy.dart';

class RepostSyncStrategy implements SyncStrategy<PostRepost> {
  RepostSyncStrategy({
    required this.createRepost,
    required this.deleteRepost,
    required this.invalidateCounterCache,
  });

  final Future<EventReference> Function(EventReference) createRepost;
  final Future<void> Function(EventReference) deleteRepost;
  final void Function(EventReference) invalidateCounterCache;

  @override
  Future<PostRepost> send(PostRepost previous, PostRepost optimistic) async {
    final toggledToRepost = optimistic.repostedByMe && !previous.repostedByMe;
    final toggledToUnrepost = !optimistic.repostedByMe && previous.repostedByMe;

    if (toggledToRepost) {
      final createdRepostReference = await createRepost(optimistic.eventReference);
      invalidateCounterCache(optimistic.eventReference);

      return optimistic.copyWith(myRepostReference: createdRepostReference);
    } else if (toggledToUnrepost) {
      if (previous.myRepostReference != null) {
        await deleteRepost(previous.myRepostReference!);
        invalidateCounterCache(optimistic.eventReference);
      }

      return optimistic;
    }

    return optimistic;
  }
}
