// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/polls/models/poll_data.c.dart';

class PollUtils {
  PollUtils._();

  /// Calculates the total number of votes from a list of vote counts
  static int calculateTotalVotes(List<int> voteCounts) {
    return voteCounts.fold(0, (sum, votes) => sum + votes);
  }

  /// Formats vote count for display (e.g., 1500 -> "1k}", 500 -> "500 ")
  static String formatVoteCount(int voteCount) {
    return voteCount >= 1000 ? '${(voteCount / 1000).toStringAsFixed(0)}k}' : '$voteCount ';
  }

  /// Returns the time remaining text for a poll
  static String getTimeRemainingText(BuildContext context, String voteText, PollData pollData) {
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
