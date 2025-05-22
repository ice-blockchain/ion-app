// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/poll/poll_data.c.dart';

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
    final formattedVotes =
        totalVotes >= 1000 ? '${(totalVotes / 1000).toStringAsFixed(0)}k}' : '$totalVotes ';

    final footerText = _getTimeRemainingText(context, formattedVotes);

    return Text(
      footerText,
      style: context.theme.appTextThemes.caption2.copyWith(
        color: context.theme.appColors.quaternaryText,
        fontSize: 12.0.s,
      ),
    );
  }

  String _getTimeRemainingText(BuildContext context, String voteText) {
    final closingTime = pollData.closingTime;

    if (pollData.isClosed) {
      return 'Votes: $voteText •  Final results';
    } else if (closingTime != null) {
      final remaining = closingTime.difference(DateTime.now());
      String timeText;

      if (remaining.inDays > 0) {
        timeText = '${remaining.inDays} ${remaining.inDays == 1 ? 'day' : 'days'}';

        final remainingHours = remaining.inHours - (remaining.inDays * 24);
        if (remainingHours > 0) {
          timeText += ' $remainingHours ${remainingHours == 1 ? 'hour' : 'hours'}';
        }
      } else if (remaining.inHours > 0) {
        timeText = '${remaining.inHours} ${remaining.inHours == 1 ? 'hour' : 'hours'}';
      } else if (remaining.inMinutes > 0) {
        timeText = '${remaining.inMinutes} ${remaining.inMinutes == 1 ? 'minute' : 'minutes'}';
      } else {
        timeText = 'less than a minute';
      }

      return 'Votes: $voteText • Left: $timeText';
    }

    return 'Votes: $voteText';
  }
}
