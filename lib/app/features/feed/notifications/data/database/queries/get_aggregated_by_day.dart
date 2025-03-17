import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class AggregatedByDayRow {
  AggregatedByDayRow({required this.date, required this.count, required this.lastReferences});

  factory AggregatedByDayRow.fromQueryRow(QueryRow row) {
    final concatenatedReferences = row.read<String>('LastReferences');
    final tags = jsonDecode('[$concatenatedReferences]') as List<dynamic>;
    final lastReferences =
        tags.map((tag) => EventReference.fromTag(List<String>.from(tag as List<dynamic>))).toList();

    return AggregatedByDayRow(
      date: row.read<String>('Date'),
      count: row.read<int>('Count'),
      lastReferences: lastReferences,
    );
  }

  final String date;
  final int count;
  final List<EventReference> lastReferences;
}

String getAggregatedByDayQuery({
  required String table,
  int maxNumOfRowsPerDay = 10,
}) {
  return '''
      WITH RowsByDate AS (
          SELECT
              *,
              DATE(datetime(created_at, 'unixepoch', 'localtime')) AS Date,
              ROW_NUMBER() OVER (PARTITION BY DATE(datetime(created_at, 'unixepoch', 'localtime')) ORDER BY created_at DESC) AS RowNum
          FROM 
              $table
      ),
      DailyCount AS (
          SELECT 
              Date,
              COUNT(*) AS Count
          FROM 
              RowsByDate
          GROUP BY 
              Date
      )
      SELECT 
          r.Date,
          GROUP_CONCAT(r.event_reference, ',' ORDER BY r.created_at DESC) AS LastReferences,
          d.Count
      FROM 
          RowsByDate r
      JOIN 
          DailyCount d ON r.Date = d.Date
      WHERE 
          r.RowNum <= $maxNumOfRowsPerDay
      GROUP BY 
          r.Date
      ORDER BY
          r.created_at DESC;
    ''';
}
