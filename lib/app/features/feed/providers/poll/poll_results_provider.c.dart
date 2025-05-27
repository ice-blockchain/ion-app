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
List<int> pollVoteCounts(Ref ref, EventReference eventReference, PollData pollData) {
  final counterEntity = ref.watch(
    ionConnectCacheProvider.select(
      cacheSelector<EventCountResultEntity>(
        EventCountResultEntity.cacheKeyBuilder(
          key: eventReference.toString(),
          type: EventCountResultType.pollVotes,
        ),
      ),
    ),
  );

  if (counterEntity != null) {
    final votesCount = counterEntity.data.content as Map<String, dynamic>;
    return List<int>.generate(
      pollData.options.length,
      (i) => (votesCount['$i'] ?? 0) as int,
    );
  }

  final allCacheEntries = ref.watch(ionConnectCacheProvider);
  final allPollVotes = allCacheEntries.values
      .map((entry) => entry.entity)
      .whereType<PollVoteEntity>()
      .where((vote) => vote.data.pollEventId == eventReference.toString())
      .toList();

  final voteCounts = List<int>.filled(pollData.options.length, 0);
  for (final vote in allPollVotes) {
    for (final optionIndex in vote.data.selectedOptionIndexes) {
      if (optionIndex >= 0 && optionIndex < voteCounts.length) {
        voteCounts[optionIndex]++;
      }
    }
  }

  return voteCounts;
}

@riverpod
PollVoteEntity? userPollVote(Ref ref, EventReference eventReference) {
  final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentUserPubkey == null) return null;

  final allCacheEntries = ref.watch(ionConnectCacheProvider);
  final allPollVotes = allCacheEntries.values
      .map((entry) => entry.entity)
      .whereType<PollVoteEntity>()
      .where(
        (vote) =>
            vote.masterPubkey == currentUserPubkey &&
            vote.data.pollEventId == eventReference.toString(),
      )
      .toList();

  return allPollVotes.firstOrNull;
}

@riverpod
int? userVotedOptionIndex(Ref ref, EventReference eventReference) {
  final userVote = ref.watch(userPollVoteProvider(eventReference));

  if (userVote != null && userVote.data.selectedOptionIndexes.isNotEmpty) {
    return userVote.data.selectedOptionIndexes.first;
  }

  return null;
}

@riverpod
bool hasUserVoted(Ref ref, EventReference eventReference) {
  return ref.watch(userPollVoteProvider(eventReference)) != null;
}

@riverpod
PollResults pollResults(
  Ref ref,
  EventReference eventReference,
  PollData pollData,
) {
  final voteCounts = ref.watch(pollVoteCountsProvider(eventReference, pollData));
  final userVotedOptionIndex = ref.watch(userVotedOptionIndexProvider(eventReference));

  return PollResults(
    voteCounts: voteCounts,
    userVotedOptionIndex: userVotedOptionIndex,
  );
}
