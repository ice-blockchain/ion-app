// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/wallet/data/coins/database/duration_type.dart';

@DataClassName('Coin')
class CoinsTable extends Table {
  TextColumn get id => text()();
  @JsonKey('contractAddress')
  TextColumn get contractAddress => text()();
  IntColumn get decimals => integer()();
  @JsonKey('iconURL')
  TextColumn get iconURL => text()();
  TextColumn get name => text()();
  TextColumn get network => text()();
  @JsonKey('priceUSD')
  RealColumn get priceUSD => real()();
  TextColumn get symbol => text()();
  @JsonKey('symbolGroup')
  TextColumn get symbolGroup => text()();
  @JsonKey('syncFrequency')
  Column<Duration> get syncFrequency => customType(const DurationType())();

  @override
  Set<Column> get primaryKey => {id};
}
