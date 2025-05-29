// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

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
    final colName = column.$name;
    return CustomExpression<int>(
      '''
      CASE
        WHEN $aliasedName.$colName < $_secThreshold
          THEN $aliasedName.$colName * $_toMicros
        ELSE $aliasedName.$colName
      END
      ''',
      watchedTables: {this},
      precedence: Precedence.primary,
    );
  }
}
