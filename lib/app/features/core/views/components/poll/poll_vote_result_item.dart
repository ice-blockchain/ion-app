// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';

class PollResultItem extends HookWidget {
  const PollResultItem({
    required this.text,
    required this.votes,
    required this.totalVotes,
    super.key,
  });

  final String text;
  final int votes;
  final int totalVotes;

  @override
  Widget build(BuildContext context) {
    final percentage = useMemoized(
      () {
        if (totalVotes == 0) return 0.0;
        return votes / totalVotes;
      },
      [votes, totalVotes],
    );

    final percentageDisplay = '${(percentage * 100).toInt()}%';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0.s),
      child: Stack(
        children: [
          // Background container
          Container(
            height: 48.0.s,
            decoration: BoxDecoration(
              color: context.theme.appColors.onTerararyFill.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24.0.s),
            ),
          ),

          // Progress indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(24.0.s),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 48.0.s,
                width: MediaQuery.of(context).size.width *
                    percentage, // Match screen width % for visually accurate bar
                decoration: BoxDecoration(
                  color: context.theme.appColors.onTerararyFill.withOpacity(0.5),
                ),
              ),
            ),
          ),

          // Text and percentage
          SizedBox(
            height: 48.0.s,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.s),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: context.theme.appTextThemes.body.copyWith(
                        color: context.theme.appColors.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    percentageDisplay,
                    style: context.theme.appTextThemes.body.copyWith(
                      color: context.theme.appColors.primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0.s,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
