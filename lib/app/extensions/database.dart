// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

extension TimestampAccessor on DatabaseAccessor {
  Future<int?> maxTimestamp<Tbl, Row>(
    ResultSetImplementation<Tbl, Row> table,
    String tableName,
    String columnName, {
    int? before,
    String? additionalQuery,
  }) async {
    return _timestamp(table, tableName, columnName, 'MAX', null, additionalQuery);
  }

  Future<int?> minTimestamp<Tbl, Row>(
    ResultSetImplementation<Tbl, Row> table,
    String tableName,
    String columnName, {
    int? after,
    String? additionalQuery,
  }) async {
    return _timestamp(table, tableName, columnName, 'MIN', after, additionalQuery);
  }

  Future<int?> _timestamp<Tbl, Row>(
    ResultSetImplementation<Tbl, Row> table,
    String tableName,
    String columnName,
    String modifier,
    int? after,
    String? additionalQuery,
  ) async {
    // anything below 1e12 we treat as seconds, so we multiply by 1_000_000
    const threshold = 1000000000000;
    const multiplier = 1000000;

    final result = await customSelect(
      '''
    SELECT $modifier(
      CASE
        WHEN $columnName < $threshold 
          THEN $columnName * $multiplier
        ELSE $columnName
      END
    ) AS normalized_ts
    FROM $tableName 
    ${additionalQuery ?? ''}
    ${after != null ? 'HAVING normalized_ts > $after' : ''};
    ''',
      readsFrom: {table},
    ).getSingleOrNull();

    return result?.data['normalized_ts'] as int?;
  }
}
