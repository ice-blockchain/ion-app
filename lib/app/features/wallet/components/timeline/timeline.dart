import 'package:flutter/material.dart';
import 'package:ice/app/features/wallet/components/timeline/timeline_item.dart';

class Timeline extends StatelessWidget {
  final List<TimelineItemData> items;

  const Timeline({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.asMap().entries.map((entry) {
        int idx = entry.key;
        TimelineItemData item = entry.value;
        return TimelineItem(
          isFirst: idx == 0,
          isLast: idx == items.length - 1,
          data: item,
        );
      }).toList(),
    );
  }
}

class TimelineItemData {
  final String title;
  final bool isDone;

  TimelineItemData({required this.title, this.isDone = false});
}
