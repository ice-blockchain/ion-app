// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/views/components/poll/poll_vote.dart';
import 'package:ion/app/features/core/views/components/poll/poll_vote_result.dart';
import 'package:ion/app/features/feed/data/models/poll/poll_data.c.dart';
import 'package:ion/app/features/feed/providers/poll/poll_vote_notifier.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class PostPoll extends ConsumerWidget {
  const PostPoll({
    required this.pollData,
    required this.voteCounts,
    required this.postReference,
    required this.hasVoted,
    required this.selectedOptionIndex,
    required this.onVoted,
    super.key,
  });

  final PollData pollData;
  final List<int> voteCounts;
  final EventReference postReference;
  final bool hasVoted;
  final int? selectedOptionIndex;
  final VoidCallback onVoted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowResults = pollData.isClosed || hasVoted;

    if (shouldShowResults) {
      return PollVoteResult(
        pollData: pollData,
        voteCounts: voteCounts,
      );
    } else {
      return PollVote(
        pollData: pollData,
        selectedOptionIndex: selectedOptionIndex,
        onVote: (optionIndex) async {
          // Call vote API
          final voteSuccess = await ref.read(pollVoteNotifierProvider.notifier).vote(
                postReference,
                optionIndex.toString(),
              );

          if (voteSuccess) {
            onVoted();
          }
        },
      );
    }
  }
}
