// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
//
// extension TimestampAccessor on DatabaseAccessor {
//   Future<int?> maxTimestamp<Tbl, Row>(
//     ResultSetImplementation<Tbl, Row> table,
//     String tableName,
//     String columnName, {
//     String? additionalQuery,
//   }) async {
//     return _timestamp(table, tableName, columnName, 'MAX', null, additionalQuery);
//   }
//
//   Future<int?> minTimestamp<Tbl, Row>(
//     ResultSetImplementation<Tbl, Row> table,
//     String tableName,
//     String columnName, {
//     int? afterTimestamp,
//     String? additionalQuery,
//   }) async {
//     return _timestamp(
//       table,
//       tableName,
//       columnName,
//       'MIN',
//       afterTimestamp,
//       additionalQuery,
//     );
//   }
//
//   Future<int?> _timestamp<Tbl, Row>(
//     ResultSetImplementation<Tbl, Row> table,
//     String tableName,
//     String columnName,
//     String modifier,
//     int? afterTimestamp,
//     String? additionalQuery,
//   ) async {
//     // anything below 1e12 we treat as seconds, so we multiply by 1_000_000
//     const threshold = 1000000000000;
//     const multiplier = 1000000;
//
//     final result = await customSelect(
//       '''
//     SELECT $modifier(
//       CASE
//         WHEN $columnName < $threshold
//           THEN $columnName * $multiplier
//         ELSE $columnName
//       END
//     ) AS normalized_ts
//     FROM $tableName
//     ${additionalQuery ?? ''}
//     ${afterTimestamp != null ? 'HAVING normalized_ts > $afterTimestamp' : ''};
//     ''',
//       readsFrom: {table},
//     ).getSingleOrNull();
//
//     return result?.data['normalized_ts'] as int?;
//   }
// }

/// Threshold to split seconds vs micros, and multiplier to go
/// from seconds → microseconds.
const _secThreshold = 1000000000000; // 1e12
const _toMicros = 1000000; // multiply seconds by this

/// Extension on **all** TableInfo instances, so you can normalize
/// _any_ GeneratedColumn<int> from seconds→micros on the fly.
extension NormalizeTimestampIntColumn<T extends Table, D> on TableInfo<T, D> {
  /// Takes any `IntColumn` and produces a `CASE … END` expression
  /// that multiplies values < 1e12 by 1e6 (seconds→micros) and
  /// leaves the rest untouched.
  Expression<int> normalizedTimestamp(GeneratedColumn<int> column) {
    final colName = column.$name; // the SQL name of the column
    return CustomExpression<int>(
      '''
      CASE
        WHEN $aliasedName.$colName < $_secThreshold
          THEN $aliasedName.$colName * $_toMicros
        ELSE $aliasedName.$colName
      END
      ''',
      watchedTables: {this}, // so streams / invalidations work
      precedence: Precedence.primary, // correct binding in comparisons
    );
  }
}
