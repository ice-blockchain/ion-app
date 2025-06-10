// SPDX-License-Identifier: ice License 1.0

class TimelineItemData {
  TimelineItemData({
    required this.title,
    this.isDone = false,
    this.date,
  });

  final String title;
  final bool isDone;
  final DateTime? date;
}
