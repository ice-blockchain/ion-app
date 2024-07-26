import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/components/timeline/timeline_item.dart';

class Timeline extends StatelessWidget {
  final List<TimelineItemData> items;

  const Timeline({Key? key, required this.items}) : super(key: key);

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
          int idx = entry.key;
          TimelineItemData item = entry.value;
          return TimelineItem(
            isLast: idx == items.length - 1,
            data: item,
            isNextDone: idx < items.length - 1 ? items[idx + 1].isDone : false,
          );
        }).toList(),
      ),
    );
  }
}

class TimelineItemData {
  final String title;
  final bool isDone;
  final DateTime? date;

  TimelineItemData({required this.title, this.isDone = false, this.date});
}
