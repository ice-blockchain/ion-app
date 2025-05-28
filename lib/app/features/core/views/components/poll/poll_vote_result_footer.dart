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
      return '${context.i18n.poll_votes}: $voteText •  ${context.i18n.poll_final_results}';
    } else if (closingTime != null) {
      final remaining = closingTime.difference(DateTime.now());
      String timeText;

      if (remaining.inDays > 0) {
        timeText = context.i18n.poll_time_day(remaining.inDays);

        final remainingHours = remaining.inHours - (remaining.inDays * 24);
        if (remainingHours > 0) {
          timeText += ' ${context.i18n.poll_time_hour(remainingHours)}';
        }
      } else if (remaining.inHours > 0) {
        timeText = context.i18n.poll_time_hour(remaining.inHours);
      } else if (remaining.inMinutes > 0) {
        timeText = context.i18n.poll_time_minute(remaining.inMinutes);
      } else {
        timeText = context.i18n.poll_time_less_than_minute;
      }

      return '${context.i18n.poll_votes}: $voteText • ${context.i18n.poll_time_left}: $timeText';
    }

    return '${context.i18n.poll_votes}: $voteText';
  }
}
