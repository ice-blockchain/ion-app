// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
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
      try {
        final createdRepostReference = await createRepost(optimistic.eventReference);
        invalidateCounterCache(optimistic.eventReference);

        final result = optimistic.copyWith(
          myRepostReference: createdRepostReference,
        );

        // Additional cache clearing if backend counter is 0
        // This can happen if multiple users unrepost simultaneously
        // Note: totalRepostsCount now returns minimum 1 if repostedByMe is true
        if (result.repostsCount == 0 && result.quotesCount == 0) {
          invalidateCounterCache(result.eventReference);
        }

        return result;
      } catch (e) {
        rethrow;
      }
    } else if (toggledToUnrepost && previous.myRepostReference != null) {
      try {
        await deleteRepost(previous.myRepostReference!);
        invalidateCounterCache(optimistic.eventReference);

        final result = optimistic.copyWith(
          myRepostReference: null,
        );

        // Additional cache clearing if backend counter is 0
        // This is necessary because backend doesn't send events when counter is 0
        if (result.repostsCount == 0 && result.quotesCount == 0) {
          invalidateCounterCache(result.eventReference);
        }

        return result;
      } catch (e) {
        // Special handling for EntityNotFoundException - the repost doesn't exist
        // This can happen if the repost was already deleted on another device
        // or if there was a sync issue
        if (e is EntityNotFoundException) {
          invalidateCounterCache(optimistic.eventReference);

          final result = optimistic.copyWith(
            myRepostReference: null,
          );

          if (result.repostsCount == 0 && result.quotesCount == 0) {
            invalidateCounterCache(result.eventReference);
          }

          return result;
        }

        rethrow;
      }
    }

    return optimistic;
  }
}
