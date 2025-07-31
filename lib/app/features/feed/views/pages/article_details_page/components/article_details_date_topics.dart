// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/date.dart';

class ArticleDetailsDateTopics extends StatelessWidget {
  const ArticleDetailsDateTopics({
    this.publishedAt,
    this.topicsNames,
    super.key,
  });

  final DateTime? publishedAt;
  final List<String>? topicsNames;

  @override
  Widget build(BuildContext context) {
    if (publishedAt == null && topicsNames == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (topicsNames != null && topicsNames!.isNotEmpty) ...[
          Row(
            children: [
              Text(
                topicsNames![0],
                style: context.theme.appTextThemes.caption.copyWith(
                  color: context.theme.appColors.quaternaryText,
                ),
              ),
              SizedBox(
                width: 6.0.s,
              ),
              if (topicsNames!.length > 1)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1.0.s, horizontal: 7.0.s),
                  decoration: BoxDecoration(
                    color: context.theme.appColors.onTertararyFill,
                    borderRadius: BorderRadius.circular(12.0.s),
                  ),
                  child: Text(
                    '+${topicsNames!.length - 1}',
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
