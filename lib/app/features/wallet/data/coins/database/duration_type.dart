// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

class DurationType implements CustomSqlType<Duration> {
  const DurationType();

  @override
  String mapToSqlLiteral(Duration dartValue) {
    return dartValue.inMilliseconds.toString();
  }

  @override
  Object mapToSqlParameter(Duration dartValue) {
    return dartValue.inMilliseconds;
  }

  @override
  Duration read(Object fromSql) {
    return Duration(milliseconds: fromSql as int);
  }

  @override
  String sqlTypeName(GenerationContext context) => 'integer';
}
