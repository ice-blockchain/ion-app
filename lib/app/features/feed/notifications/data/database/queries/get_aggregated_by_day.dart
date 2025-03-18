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
  int maxPubkeysPerItem = 10,
}) {
  return '''
      WITH DailyLikes AS (
          SELECT
              DATE(datetime(created_at, 'unixepoch', 'localtime')) AS event_date,
              event_id,
              pubkey,
              created_at,
              ROW_NUMBER() OVER (PARTITION BY DATE(datetime(created_at, 'unixepoch', 'localtime')), event_id 
                  ORDER BY created_at DESC) AS rn
          FROM
              $table
      )
      SELECT 
          event_date,
          event_id,
          GROUP_CONCAT(CASE WHEN rn <= $maxPubkeysPerItem THEN pubkey END, ',') AS latest_pubkeys,
          COUNT(DISTINCT pubkey) AS unique_pubkey_count
      FROM 
          DailyLikes
      GROUP BY 
          event_date, event_id
      ORDER BY
          event_date DESC, event_id DESC;
    ''';
}
