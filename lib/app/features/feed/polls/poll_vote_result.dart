// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/poll/poll_data.c.dart';
import 'package:ion/app/features/feed/polls/poll_utils.dart';
import 'package:ion/app/features/feed/polls/poll_vote_result_footer.dart';
import 'package:ion/app/features/feed/polls/poll_vote_result_item.dart';

class PollVoteResult extends ConsumerWidget {
  const PollVoteResult({
    required this.pollData,
    required this.voteCounts,
    this.userVotedOptionIndex,
    super.key,
  });

  final PollData pollData;
  final List<int> voteCounts;
  final int? userVotedOptionIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalVotes = PollUtils.calculateTotalVotes(voteCounts);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          pollData.options.length,
          (index) {
            return PollResultItem(
              text: pollData.options[index],
              votes: voteCounts[index],
              totalVotes: totalVotes,
              isSelected: userVotedOptionIndex == index,
            );
          },
        ),
        SizedBox(height: 6.0.s),
        PollVoteResultFooter(
          pollData: pollData,
          totalVotes: totalVotes,
        ),
      ],
    );
  }
}
