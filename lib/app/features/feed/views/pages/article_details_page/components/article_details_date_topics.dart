// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/date.dart';

class ArticleDetailsDateTopics extends StatelessWidget {
  const ArticleDetailsDateTopics({
    this.publishedAt,
    this.topics,
    super.key,
  });

  final DateTime? publishedAt;
  final List<String>? topics;

  @override
  Widget build(BuildContext context) {
    if (publishedAt == null && topics == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (topics != null && topics!.isNotEmpty) ...[
          Row(
            children: [
              Text(
                topics![0],
                style: context.theme.appTextThemes.caption.copyWith(
                  color: context.theme.appColors.quaternaryText,
                ),
              ),
              SizedBox(
                width: 6.0.s,
              ),
              if (topics!.length > 1)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1.0.s, horizontal: 7.0.s),
                  decoration: BoxDecoration(
                    color: context.theme.appColors.onTerararyFill,
                    borderRadius: BorderRadius.circular(12.0.s),
                  ),
                  child: Text(
                    '+${topics!.length - 1}',
                    style: context.theme.appTextThemes.caption.copyWith(
                      color: context.theme.appColors.primaryAccent,
                    ),
                  ),
                ),
            ],
          ),
        ],
        if (publishedAt != null)
          Text(
            formatDateToMonthDayYear(publishedAt!),
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.quaternaryText,
            ),
          ),
      ],
    );
  }
}
