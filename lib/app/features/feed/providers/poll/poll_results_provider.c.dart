// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/feed/data/models/poll/poll_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/pole_vote.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// part directive for codegen
part 'poll_results_provider.c.g.dart';

class PollResults {
  const PollResults({
    required this.voteCounts,
    required this.userVotedOptionIndex,
  });
  final List<int> voteCounts;
  final int? userVotedOptionIndex;
}

@riverpod
PollResults pollResults(
  Ref ref,
  EventReference pollEventReference,
  PollData pollData,
) {
  final entity = ref.watch(
    ionConnectCacheProvider.select(
      cacheSelector<EventCountResultEntity>(
        EventCountResultEntity.cacheKeyBuilder(
          key: pollEventReference.toString(),
          type: EventCountResultType.pollVotes,
        ),
      ),
    ),
  );

  final countsMap = entity?.data.content as Map<String, dynamic>? ?? {};
  final voteCounts = List<int>.generate(
    pollData.options.length,
    (i) => (countsMap['$i'] ?? 0) as int,
  );

  // Get current user's voted option index
  final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
  int? userVotedOptionIndex;

  if (currentUserPubkey != null) {
    // Get the actual poll entity to get its real event ID
    final pollEntity = ref.watch(
      ionConnectCacheProvider.select(
        cacheSelector(CacheableEntity.cacheKeyBuilder(eventReference: pollEventReference)),
      ),
    );

    // Look for user's vote entity in cache
    final userVoteEntity = ref.watch(
      ionConnectCacheProvider.select(
        (cache) => cache.values.map((entry) => entry.entity).whereType<PollVoteEntity>().where(
          (vote) {
            final isCurrentUser = vote.masterPubkey == currentUserPubkey;

            // Compare against the actual poll event ID (not the reference)
            final targetEventId = pollEntity?.id;
            final eventIdMatch = targetEventId != null && vote.data.pollEventId == targetEventId;

            return isCurrentUser && eventIdMatch;
          },
        ).firstOrNull,
      ),
    );

    if (userVoteEntity != null && userVoteEntity.data.selectedOptionIndexes.isNotEmpty) {
      userVotedOptionIndex = userVoteEntity.data.selectedOptionIndexes.first;
    }
  }

  return PollResults(
    voteCounts: voteCounts,
    userVotedOptionIndex: userVotedOptionIndex,
  );
}
