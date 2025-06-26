// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/polls/models/poll_data.f.dart';
import 'package:ion/app/features/feed/polls/providers/poll_results_provider.r.dart';
import 'package:ion/app/features/feed/polls/providers/poll_vote_notifier.m.dart';
import 'package:ion/app/features/feed/polls/view/components/poll_vote.dart';
import 'package:ion/app/features/feed/polls/view/components/poll_vote_result.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';

class PostPoll extends ConsumerWidget {
  const PostPoll({
    required this.pollData,
    required this.postReference,
    super.key,
  });

  final PollData pollData;
  final EventReference postReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voteCounts = ref.watch(pollVoteCountsProvider(postReference, pollData));
    final userVotedOptionIndex = ref.watch(userVotedOptionIndexProvider(postReference));
    final hasVoted = ref.watch(hasUserVotedProvider(postReference));

    final userHasVoted = userVotedOptionIndex != null || hasVoted;
    final shouldShowResults = pollData.isClosed || userHasVoted;

    if (shouldShowResults) {
      return PollVoteResult(
        pollData: pollData,
        voteCounts: voteCounts,
        userVotedOptionIndex: userVotedOptionIndex,
      );
    } else {
      return PollVote(
        pollData: pollData,
        selectedOptionIndex: userVotedOptionIndex,
        onVote: (optionIndex) async {
          await ref.read(pollVoteNotifierProvider.notifier).vote(
                postReference,
                optionIndex.toString(),
              );
        },
      );
    }
  }
}
