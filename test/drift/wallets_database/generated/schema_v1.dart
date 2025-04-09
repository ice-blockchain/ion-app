// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class CoinsTable extends Table with TableInfo<CoinsTable, CoinsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CoinsTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> contractAddress = GeneratedColumn<String>(
      'contract_address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> decimals = GeneratedColumn<int>(
      'decimals', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> iconURL = GeneratedColumn<String>(
      'icon_u_r_l', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> networkId = GeneratedColumn<String>(
      'network_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<double> priceUSD = GeneratedColumn<double>(
      'price_u_s_d', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> symbolGroup = GeneratedColumn<String>(
      'symbol_group', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> syncFrequency = GeneratedColumn<int>(
      'sync_frequency', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        contractAddress,
        decimals,
        iconURL,
        name,
        networkId,
        priceUSD,
        symbol,
        symbolGroup,
        syncFrequency
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coins_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoinsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoinsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      contractAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}contract_address'])!,
      decimals: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}decimals'])!,
      iconURL: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_u_r_l'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      networkId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}network_id'])!,
      priceUSD: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_u_s_d'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      symbolGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol_group'])!,
      syncFrequency: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_frequency'])!,
    );
  }

  @override
  CoinsTable createAlias(String alias) {
    return CoinsTable(attachedDatabase, alias);
  }
}

class CoinsTableData extends DataClass implements Insertable<CoinsTableData> {
  final String id;
  final String contractAddress;
  final int decimals;
  final String iconURL;
  final String name;
  final String networkId;
  final double priceUSD;
  final String symbol;
  final String symbolGroup;
  final int syncFrequency;
  const CoinsTableData(
      {required this.id,
      required this.contractAddress,
      required this.decimals,
      required this.iconURL,
      required this.name,
      required this.networkId,
      required this.priceUSD,
      required this.symbol,
      required this.symbolGroup,
      required this.syncFrequency});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['contract_address'] = Variable<String>(contractAddress);
    map['decimals'] = Variable<int>(decimals);
    map['icon_u_r_l'] = Variable<String>(iconURL);
    map['name'] = Variable<String>(name);
    map['network_id'] = Variable<String>(networkId);
    map['price_u_s_d'] = Variable<double>(priceUSD);
    map['symbol'] = Variable<String>(symbol);
    map['symbol_group'] = Variable<String>(symbolGroup);
    map['sync_frequency'] = Variable<int>(syncFrequency);
    return map;
  }

  CoinsTableCompanion toCompanion(bool nullToAbsent) {
    return CoinsTableCompanion(
      id: Value(id),
      contractAddress: Value(contractAddress),
      decimals: Value(decimals),
      iconURL: Value(iconURL),
      name: Value(name),
      networkId: Value(networkId),
      priceUSD: Value(priceUSD),
      symbol: Value(symbol),
      symbolGroup: Value(symbolGroup),
      syncFrequency: Value(syncFrequency),
    );
  }

  factory CoinsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoinsTableData(
      id: serializer.fromJson<String>(json['id']),
      contractAddress: serializer.fromJson<String>(json['contract_address']),
      decimals: serializer.fromJson<int>(json['decimals']),
      iconURL: serializer.fromJson<String>(json['icon_u_r_l']),
      name: serializer.fromJson<String>(json['name']),
      networkId: serializer.fromJson<String>(json['network_id']),
      priceUSD: serializer.fromJson<double>(json['price_u_s_d']),
      symbol: serializer.fromJson<String>(json['symbol']),
      symbolGroup: serializer.fromJson<String>(json['symbol_group']),
      syncFrequency: serializer.fromJson<int>(json['sync_frequency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'contract_address': serializer.toJson<String>(contractAddress),
      'decimals': serializer.toJson<int>(decimals),
      'icon_u_r_l': serializer.toJson<String>(iconURL),
      'name': serializer.toJson<String>(name),
      'network_id': serializer.toJson<String>(networkId),
      'price_u_s_d': serializer.toJson<double>(priceUSD),
      'symbol': serializer.toJson<String>(symbol),
      'symbol_group': serializer.toJson<String>(symbolGroup),
      'sync_frequency': serializer.toJson<int>(syncFrequency),
    };
  }

  CoinsTableData copyWith(
          {String? id,
          String? contractAddress,
          int? decimals,
          String? iconURL,
          String? name,
          String? networkId,
          double? priceUSD,
          String? symbol,
          String? symbolGroup,
          int? syncFrequency}) =>
      CoinsTableData(
        id: id ?? this.id,
        contractAddress: contractAddress ?? this.contractAddress,
        decimals: decimals ?? this.decimals,
        iconURL: iconURL ?? this.iconURL,
        name: name ?? this.name,
        networkId: networkId ?? this.networkId,
        priceUSD: priceUSD ?? this.priceUSD,
        symbol: symbol ?? this.symbol,
        symbolGroup: symbolGroup ?? this.symbolGroup,
        syncFrequency: syncFrequency ?? this.syncFrequency,
      );
  CoinsTableData copyWithCompanion(CoinsTableCompanion data) {
    return CoinsTableData(
      id: data.id.present ? data.id.value : this.id,
      contractAddress: data.contractAddress.present
          ? data.contractAddress.value
          : this.contractAddress,
      decimals: data.decimals.present ? data.decimals.value : this.decimals,
      iconURL: data.iconURL.present ? data.iconURL.value : this.iconURL,
      name: data.name.present ? data.name.value : this.name,
      networkId: data.networkId.present ? data.networkId.value : this.networkId,
      priceUSD: data.priceUSD.present ? data.priceUSD.value : this.priceUSD,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      symbolGroup:
          data.symbolGroup.present ? data.symbolGroup.value : this.symbolGroup,
      syncFrequency: data.syncFrequency.present
          ? data.syncFrequency.value
          : this.syncFrequency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoinsTableData(')
          ..write('id: $id, ')
          ..write('contractAddress: $contractAddress, ')
          ..write('decimals: $decimals, ')
          ..write('iconURL: $iconURL, ')
          ..write('name: $name, ')
          ..write('networkId: $networkId, ')
          ..write('priceUSD: $priceUSD, ')
          ..write('symbol: $symbol, ')
          ..write('symbolGroup: $symbolGroup, ')
          ..write('syncFrequency: $syncFrequency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, contractAddress, decimals, iconURL, name,
      networkId, priceUSD, symbol, symbolGroup, syncFrequency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoinsTableData &&
          other.id == this.id &&
          other.contractAddress == this.contractAddress &&
          other.decimals == this.decimals &&
          other.iconURL == this.iconURL &&
          other.name == this.name &&
          other.networkId == this.networkId &&
          other.priceUSD == this.priceUSD &&
          other.symbol == this.symbol &&
          other.symbolGroup == this.symbolGroup &&
          other.syncFrequency == this.syncFrequency);
}

class CoinsTableCompanion extends UpdateCompanion<CoinsTableData> {
  final Value<String> id;
  final Value<String> contractAddress;
  final Value<int> decimals;
  final Value<String> iconURL;
  final Value<String> name;
  final Value<String> networkId;
  final Value<double> priceUSD;
  final Value<String> symbol;
  final Value<String> symbolGroup;
  final Value<int> syncFrequency;
  final Value<int> rowid;
  const CoinsTableCompanion({
    this.id = const Value.absent(),
    this.contractAddress = const Value.absent(),
    this.decimals = const Value.absent(),
    this.iconURL = const Value.absent(),
    this.name = const Value.absent(),
    this.networkId = const Value.absent(),
    this.priceUSD = const Value.absent(),
    this.symbol = const Value.absent(),
    this.symbolGroup = const Value.absent(),
    this.syncFrequency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoinsTableCompanion.insert({
    required String id,
    required String contractAddress,
    required int decimals,
    required String iconURL,
    required String name,
    required String networkId,
    required double priceUSD,
    required String symbol,
    required String symbolGroup,
    required int syncFrequency,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        contractAddress = Value(contractAddress),
        decimals = Value(decimals),
        iconURL = Value(iconURL),
        name = Value(name),
        networkId = Value(networkId),
        priceUSD = Value(priceUSD),
        symbol = Value(symbol),
        symbolGroup = Value(symbolGroup),
        syncFrequency = Value(syncFrequency);
  static Insertable<CoinsTableData> custom({
    Expression<String>? id,
    Expression<String>? contractAddress,
    Expression<int>? decimals,
    Expression<String>? iconURL,
    Expression<String>? name,
    Expression<String>? networkId,
    Expression<double>? priceUSD,
    Expression<String>? symbol,
    Expression<String>? symbolGroup,
    Expression<int>? syncFrequency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contractAddress != null) 'contract_address': contractAddress,
      if (decimals != null) 'decimals': decimals,
      if (iconURL != null) 'icon_u_r_l': iconURL,
      if (name != null) 'name': name,
      if (networkId != null) 'network_id': networkId,
      if (priceUSD != null) 'price_u_s_d': priceUSD,
      if (symbol != null) 'symbol': symbol,
      if (symbolGroup != null) 'symbol_group': symbolGroup,
      if (syncFrequency != null) 'sync_frequency': syncFrequency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoinsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? contractAddress,
      Value<int>? decimals,
      Value<String>? iconURL,
      Value<String>? name,
      Value<String>? networkId,
      Value<double>? priceUSD,
      Value<String>? symbol,
      Value<String>? symbolGroup,
      Value<int>? syncFrequency,
      Value<int>? rowid}) {
    return CoinsTableCompanion(
      id: id ?? this.id,
      contractAddress: contractAddress ?? this.contractAddress,
      decimals: decimals ?? this.decimals,
      iconURL: iconURL ?? this.iconURL,
      name: name ?? this.name,
      networkId: networkId ?? this.networkId,
      priceUSD: priceUSD ?? this.priceUSD,
      symbol: symbol ?? this.symbol,
      symbolGroup: symbolGroup ?? this.symbolGroup,
      syncFrequency: syncFrequency ?? this.syncFrequency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (contractAddress.present) {
      map['contract_address'] = Variable<String>(contractAddress.value);
    }
    if (decimals.present) {
      map['decimals'] = Variable<int>(decimals.value);
    }
    if (iconURL.present) {
      map['icon_u_r_l'] = Variable<String>(iconURL.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (networkId.present) {
      map['network_id'] = Variable<String>(networkId.value);
    }
    if (priceUSD.present) {
      map['price_u_s_d'] = Variable<double>(priceUSD.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (symbolGroup.present) {
      map['symbol_group'] = Variable<String>(symbolGroup.value);
    }
    if (syncFrequency.present) {
      map['sync_frequency'] = Variable<int>(syncFrequency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoinsTableCompanion(')
          ..write('id: $id, ')
          ..write('contractAddress: $contractAddress, ')
          ..write('decimals: $decimals, ')
          ..write('iconURL: $iconURL, ')
          ..write('name: $name, ')
          ..write('networkId: $networkId, ')
          ..write('priceUSD: $priceUSD, ')
          ..write('symbol: $symbol, ')
          ..write('symbolGroup: $symbolGroup, ')
          ..write('syncFrequency: $syncFrequency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class SyncCoinsTable extends Table
    with TableInfo<SyncCoinsTable, SyncCoinsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SyncCoinsTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> coinId = GeneratedColumn<String>(
      'coin_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> syncAfter = GeneratedColumn<DateTime>(
      'sync_after', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [coinId, syncAfter];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_coins_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {coinId};
  @override
  SyncCoinsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCoinsTableData(
      coinId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coin_id'])!,
      syncAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sync_after'])!,
    );
  }

  @override
  SyncCoinsTable createAlias(String alias) {
    return SyncCoinsTable(attachedDatabase, alias);
  }
}

class SyncCoinsTableData extends DataClass
    implements Insertable<SyncCoinsTableData> {
  final String coinId;
  final DateTime syncAfter;
  const SyncCoinsTableData({required this.coinId, required this.syncAfter});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['coin_id'] = Variable<String>(coinId);
    map['sync_after'] = Variable<DateTime>(syncAfter);
    return map;
  }

  SyncCoinsTableCompanion toCompanion(bool nullToAbsent) {
    return SyncCoinsTableCompanion(
      coinId: Value(coinId),
      syncAfter: Value(syncAfter),
    );
  }

  factory SyncCoinsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCoinsTableData(
      coinId: serializer.fromJson<String>(json['coin_id']),
      syncAfter: serializer.fromJson<DateTime>(json['sync_after']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'coin_id': serializer.toJson<String>(coinId),
      'sync_after': serializer.toJson<DateTime>(syncAfter),
    };
  }

  SyncCoinsTableData copyWith({String? coinId, DateTime? syncAfter}) =>
      SyncCoinsTableData(
        coinId: coinId ?? this.coinId,
        syncAfter: syncAfter ?? this.syncAfter,
      );
  SyncCoinsTableData copyWithCompanion(SyncCoinsTableCompanion data) {
    return SyncCoinsTableData(
      coinId: data.coinId.present ? data.coinId.value : this.coinId,
      syncAfter: data.syncAfter.present ? data.syncAfter.value : this.syncAfter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCoinsTableData(')
          ..write('coinId: $coinId, ')
          ..write('syncAfter: $syncAfter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(coinId, syncAfter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCoinsTableData &&
          other.coinId == this.coinId &&
          other.syncAfter == this.syncAfter);
}

class SyncCoinsTableCompanion extends UpdateCompanion<SyncCoinsTableData> {
  final Value<String> coinId;
  final Value<DateTime> syncAfter;
  final Value<int> rowid;
  const SyncCoinsTableCompanion({
    this.coinId = const Value.absent(),
    this.syncAfter = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCoinsTableCompanion.insert({
    required String coinId,
    required DateTime syncAfter,
    this.rowid = const Value.absent(),
  })  : coinId = Value(coinId),
        syncAfter = Value(syncAfter);
  static Insertable<SyncCoinsTableData> custom({
    Expression<String>? coinId,
    Expression<DateTime>? syncAfter,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (coinId != null) 'coin_id': coinId,
      if (syncAfter != null) 'sync_after': syncAfter,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCoinsTableCompanion copyWith(
      {Value<String>? coinId, Value<DateTime>? syncAfter, Value<int>? rowid}) {
    return SyncCoinsTableCompanion(
      coinId: coinId ?? this.coinId,
      syncAfter: syncAfter ?? this.syncAfter,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (coinId.present) {
      map['coin_id'] = Variable<String>(coinId.value);
    }
    if (syncAfter.present) {
      map['sync_after'] = Variable<DateTime>(syncAfter.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCoinsTableCompanion(')
          ..write('coinId: $coinId, ')
          ..write('syncAfter: $syncAfter, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class NetworksTable extends Table
    with TableInfo<NetworksTable, NetworksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  NetworksTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> isTestnet = GeneratedColumn<bool>(
      'is_testnet', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_testnet" IN (0, 1))'));
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> explorerUrl = GeneratedColumn<String>(
      'explorer_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, image, isTestnet, displayName, explorerUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'networks_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NetworksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NetworksTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image'])!,
      isTestnet: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_testnet'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      explorerUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explorer_url'])!,
    );
  }

  @override
  NetworksTable createAlias(String alias) {
    return NetworksTable(attachedDatabase, alias);
  }
}

class NetworksTableData extends DataClass
    implements Insertable<NetworksTableData> {
  final String id;
  final String image;
  final bool isTestnet;
  final String displayName;
  final String explorerUrl;
  const NetworksTableData(
      {required this.id,
      required this.image,
      required this.isTestnet,
      required this.displayName,
      required this.explorerUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['image'] = Variable<String>(image);
    map['is_testnet'] = Variable<bool>(isTestnet);
    map['display_name'] = Variable<String>(displayName);
    map['explorer_url'] = Variable<String>(explorerUrl);
    return map;
  }

  NetworksTableCompanion toCompanion(bool nullToAbsent) {
    return NetworksTableCompanion(
      id: Value(id),
      image: Value(image),
      isTestnet: Value(isTestnet),
      displayName: Value(displayName),
      explorerUrl: Value(explorerUrl),
    );
  }

  factory NetworksTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NetworksTableData(
      id: serializer.fromJson<String>(json['id']),
      image: serializer.fromJson<String>(json['image']),
      isTestnet: serializer.fromJson<bool>(json['is_testnet']),
      displayName: serializer.fromJson<String>(json['display_name']),
      explorerUrl: serializer.fromJson<String>(json['explorer_url']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'image': serializer.toJson<String>(image),
      'is_testnet': serializer.toJson<bool>(isTestnet),
      'display_name': serializer.toJson<String>(displayName),
      'explorer_url': serializer.toJson<String>(explorerUrl),
    };
  }

  NetworksTableData copyWith(
          {String? id,
          String? image,
          bool? isTestnet,
          String? displayName,
          String? explorerUrl}) =>
      NetworksTableData(
        id: id ?? this.id,
        image: image ?? this.image,
        isTestnet: isTestnet ?? this.isTestnet,
        displayName: displayName ?? this.displayName,
        explorerUrl: explorerUrl ?? this.explorerUrl,
      );
  NetworksTableData copyWithCompanion(NetworksTableCompanion data) {
    return NetworksTableData(
      id: data.id.present ? data.id.value : this.id,
      image: data.image.present ? data.image.value : this.image,
      isTestnet: data.isTestnet.present ? data.isTestnet.value : this.isTestnet,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      explorerUrl:
          data.explorerUrl.present ? data.explorerUrl.value : this.explorerUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NetworksTableData(')
          ..write('id: $id, ')
          ..write('image: $image, ')
          ..write('isTestnet: $isTestnet, ')
          ..write('displayName: $displayName, ')
          ..write('explorerUrl: $explorerUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, image, isTestnet, displayName, explorerUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NetworksTableData &&
          other.id == this.id &&
          other.image == this.image &&
          other.isTestnet == this.isTestnet &&
          other.displayName == this.displayName &&
          other.explorerUrl == this.explorerUrl);
}

class NetworksTableCompanion extends UpdateCompanion<NetworksTableData> {
  final Value<String> id;
  final Value<String> image;
  final Value<bool> isTestnet;
  final Value<String> displayName;
  final Value<String> explorerUrl;
  final Value<int> rowid;
  const NetworksTableCompanion({
    this.id = const Value.absent(),
    this.image = const Value.absent(),
    this.isTestnet = const Value.absent(),
    this.displayName = const Value.absent(),
    this.explorerUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NetworksTableCompanion.insert({
    required String id,
    required String image,
    required bool isTestnet,
    required String displayName,
    required String explorerUrl,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        image = Value(image),
        isTestnet = Value(isTestnet),
        displayName = Value(displayName),
        explorerUrl = Value(explorerUrl);
  static Insertable<NetworksTableData> custom({
    Expression<String>? id,
    Expression<String>? image,
    Expression<bool>? isTestnet,
    Expression<String>? displayName,
    Expression<String>? explorerUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (image != null) 'image': image,
      if (isTestnet != null) 'is_testnet': isTestnet,
      if (displayName != null) 'display_name': displayName,
      if (explorerUrl != null) 'explorer_url': explorerUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NetworksTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? image,
      Value<bool>? isTestnet,
      Value<String>? displayName,
      Value<String>? explorerUrl,
      Value<int>? rowid}) {
    return NetworksTableCompanion(
      id: id ?? this.id,
      image: image ?? this.image,
      isTestnet: isTestnet ?? this.isTestnet,
      displayName: displayName ?? this.displayName,
      explorerUrl: explorerUrl ?? this.explorerUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (isTestnet.present) {
      map['is_testnet'] = Variable<bool>(isTestnet.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (explorerUrl.present) {
      map['explorer_url'] = Variable<String>(explorerUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NetworksTableCompanion(')
          ..write('id: $id, ')
          ..write('image: $image, ')
          ..write('isTestnet: $isTestnet, ')
          ..write('displayName: $displayName, ')
          ..write('explorerUrl: $explorerUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final CoinsTable coinsTable = CoinsTable(this);
  late final SyncCoinsTable syncCoinsTable = SyncCoinsTable(this);
  late final NetworksTable networksTable = NetworksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [coinsTable, syncCoinsTable, networksTable];
  @override
  int get schemaVersion => 1;
}
