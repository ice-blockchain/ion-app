// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/polls/models/poll_data.c.dart';
import 'package:ion/app/features/feed/polls/utils/poll_utils.dart';

class PollVoteResultFooter extends StatelessWidget {
  const PollVoteResultFooter({
    required this.pollData,
    required this.totalVotes,
    super.key,
  });

  final PollData pollData;
  final int totalVotes;

  @override
  Widget build(BuildContext context) {
    final formattedVotes = PollUtils.formatVoteCount(totalVotes);

    final footerText = PollUtils.getTimeRemainingText(context, formattedVotes, pollData);

    return Text(
      footerText,
      style: context.theme.appTextThemes.caption2.copyWith(
        color: context.theme.appColors.quaternaryText,
        fontSize: 12.0.s,
      ),
    );
  }
}
