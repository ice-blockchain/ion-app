// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/data/models/timeline_item_data.dart';
import 'package:ion/app/features/wallets/views/components/timeline/timeline_item.dart';

class Timeline extends StatelessWidget {
  const Timeline({
    required this.items,
    super.key,
  });
  final List<TimelineItemData> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        color: context.theme.appColors.tertararyBackground,
      ),
      padding: EdgeInsets.all(12.0.s),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return TimelineItem(
            isLast: idx == items.length - 1,
            data: item,
            isNextDone: (idx < items.length - 1) && items[idx + 1].isDone,
          );
        }).toList(),
      ),
    );
  }
}
