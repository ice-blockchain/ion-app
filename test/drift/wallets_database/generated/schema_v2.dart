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

class TransactionsTable extends Table
    with TableInfo<TransactionsTable, TransactionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TransactionsTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> txHash = GeneratedColumn<String>(
      'tx_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> networkId = GeneratedColumn<String>(
      'network_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> coinId = GeneratedColumn<String>(
      'coin_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> senderWalletAddress =
      GeneratedColumn<String>('sender_wallet_address', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> receiverWalletAddress =
      GeneratedColumn<String>('receiver_wallet_address', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> fee = GeneratedColumn<String>(
      'fee', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> nativeCoinId = GeneratedColumn<String>(
      'native_coin_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> dateConfirmed =
      GeneratedColumn<DateTime>('date_confirmed', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> dateRequested =
      GeneratedColumn<DateTime>('date_requested', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> createdAtInRelay =
      GeneratedColumn<DateTime>('created_at_in_relay', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> userPubkey = GeneratedColumn<String>(
      'user_pubkey', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
      'asset_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> transferredAmount =
      GeneratedColumn<String>('transferred_amount', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<double> transferredAmountUsd =
      GeneratedColumn<double>('transferred_amount_usd', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  late final GeneratedColumn<String> balanceBeforeTransfer =
      GeneratedColumn<String>('balance_before_transfer', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        type,
        txHash,
        networkId,
        coinId,
        senderWalletAddress,
        receiverWalletAddress,
        id,
        fee,
        status,
        nativeCoinId,
        dateConfirmed,
        dateRequested,
        createdAtInRelay,
        userPubkey,
        assetId,
        transferredAmount,
        transferredAmountUsd,
        balanceBeforeTransfer
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {txHash};
  @override
  TransactionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsTableData(
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      txHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tx_hash'])!,
      networkId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}network_id'])!,
      coinId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coin_id']),
      senderWalletAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sender_wallet_address'])!,
      receiverWalletAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}receiver_wallet_address'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id']),
      fee: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fee']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      nativeCoinId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}native_coin_id']),
      dateConfirmed: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_confirmed']),
      dateRequested: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_requested']),
      createdAtInRelay: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}created_at_in_relay']),
      userPubkey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_pubkey']),
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_id']),
      transferredAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transferred_amount']),
      transferredAmountUsd: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}transferred_amount_usd']),
      balanceBeforeTransfer: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}balance_before_transfer']),
    );
  }

  @override
  TransactionsTable createAlias(String alias) {
    return TransactionsTable(attachedDatabase, alias);
  }
}

class TransactionsTableData extends DataClass
    implements Insertable<TransactionsTableData> {
  final String type;
  final String txHash;
  final String networkId;
  final String? coinId;
  final String senderWalletAddress;
  final String receiverWalletAddress;
  final String? id;
  final String? fee;
  final String? status;
  final String? nativeCoinId;
  final DateTime? dateConfirmed;
  final DateTime? dateRequested;
  final DateTime? createdAtInRelay;
  final String? userPubkey;
  final String? assetId;
  final String? transferredAmount;
  final double? transferredAmountUsd;
  final String? balanceBeforeTransfer;
  const TransactionsTableData(
      {required this.type,
      required this.txHash,
      required this.networkId,
      this.coinId,
      required this.senderWalletAddress,
      required this.receiverWalletAddress,
      this.id,
      this.fee,
      this.status,
      this.nativeCoinId,
      this.dateConfirmed,
      this.dateRequested,
      this.createdAtInRelay,
      this.userPubkey,
      this.assetId,
      this.transferredAmount,
      this.transferredAmountUsd,
      this.balanceBeforeTransfer});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['type'] = Variable<String>(type);
    map['tx_hash'] = Variable<String>(txHash);
    map['network_id'] = Variable<String>(networkId);
    if (!nullToAbsent || coinId != null) {
      map['coin_id'] = Variable<String>(coinId);
    }
    map['sender_wallet_address'] = Variable<String>(senderWalletAddress);
    map['receiver_wallet_address'] = Variable<String>(receiverWalletAddress);
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || fee != null) {
      map['fee'] = Variable<String>(fee);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || nativeCoinId != null) {
      map['native_coin_id'] = Variable<String>(nativeCoinId);
    }
    if (!nullToAbsent || dateConfirmed != null) {
      map['date_confirmed'] = Variable<DateTime>(dateConfirmed);
    }
    if (!nullToAbsent || dateRequested != null) {
      map['date_requested'] = Variable<DateTime>(dateRequested);
    }
    if (!nullToAbsent || createdAtInRelay != null) {
      map['created_at_in_relay'] = Variable<DateTime>(createdAtInRelay);
    }
    if (!nullToAbsent || userPubkey != null) {
      map['user_pubkey'] = Variable<String>(userPubkey);
    }
    if (!nullToAbsent || assetId != null) {
      map['asset_id'] = Variable<String>(assetId);
    }
    if (!nullToAbsent || transferredAmount != null) {
      map['transferred_amount'] = Variable<String>(transferredAmount);
    }
    if (!nullToAbsent || transferredAmountUsd != null) {
      map['transferred_amount_usd'] = Variable<double>(transferredAmountUsd);
    }
    if (!nullToAbsent || balanceBeforeTransfer != null) {
      map['balance_before_transfer'] = Variable<String>(balanceBeforeTransfer);
    }
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      type: Value(type),
      txHash: Value(txHash),
      networkId: Value(networkId),
      coinId:
          coinId == null && nullToAbsent ? const Value.absent() : Value(coinId),
      senderWalletAddress: Value(senderWalletAddress),
      receiverWalletAddress: Value(receiverWalletAddress),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      fee: fee == null && nullToAbsent ? const Value.absent() : Value(fee),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      nativeCoinId: nativeCoinId == null && nullToAbsent
          ? const Value.absent()
          : Value(nativeCoinId),
      dateConfirmed: dateConfirmed == null && nullToAbsent
          ? const Value.absent()
          : Value(dateConfirmed),
      dateRequested: dateRequested == null && nullToAbsent
          ? const Value.absent()
          : Value(dateRequested),
      createdAtInRelay: createdAtInRelay == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAtInRelay),
      userPubkey: userPubkey == null && nullToAbsent
          ? const Value.absent()
          : Value(userPubkey),
      assetId: assetId == null && nullToAbsent
          ? const Value.absent()
          : Value(assetId),
      transferredAmount: transferredAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(transferredAmount),
      transferredAmountUsd: transferredAmountUsd == null && nullToAbsent
          ? const Value.absent()
          : Value(transferredAmountUsd),
      balanceBeforeTransfer: balanceBeforeTransfer == null && nullToAbsent
          ? const Value.absent()
          : Value(balanceBeforeTransfer),
    );
  }

  factory TransactionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsTableData(
      type: serializer.fromJson<String>(json['type']),
      txHash: serializer.fromJson<String>(json['tx_hash']),
      networkId: serializer.fromJson<String>(json['network_id']),
      coinId: serializer.fromJson<String?>(json['coin_id']),
      senderWalletAddress:
          serializer.fromJson<String>(json['sender_wallet_address']),
      receiverWalletAddress:
          serializer.fromJson<String>(json['receiver_wallet_address']),
      id: serializer.fromJson<String?>(json['id']),
      fee: serializer.fromJson<String?>(json['fee']),
      status: serializer.fromJson<String?>(json['status']),
      nativeCoinId: serializer.fromJson<String?>(json['native_coin_id']),
      dateConfirmed: serializer.fromJson<DateTime?>(json['date_confirmed']),
      dateRequested: serializer.fromJson<DateTime?>(json['date_requested']),
      createdAtInRelay:
          serializer.fromJson<DateTime?>(json['created_at_in_relay']),
      userPubkey: serializer.fromJson<String?>(json['user_pubkey']),
      assetId: serializer.fromJson<String?>(json['asset_id']),
      transferredAmount:
          serializer.fromJson<String?>(json['transferred_amount']),
      transferredAmountUsd:
          serializer.fromJson<double?>(json['transferred_amount_usd']),
      balanceBeforeTransfer:
          serializer.fromJson<String?>(json['balance_before_transfer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'type': serializer.toJson<String>(type),
      'tx_hash': serializer.toJson<String>(txHash),
      'network_id': serializer.toJson<String>(networkId),
      'coin_id': serializer.toJson<String?>(coinId),
      'sender_wallet_address': serializer.toJson<String>(senderWalletAddress),
      'receiver_wallet_address':
          serializer.toJson<String>(receiverWalletAddress),
      'id': serializer.toJson<String?>(id),
      'fee': serializer.toJson<String?>(fee),
      'status': serializer.toJson<String?>(status),
      'native_coin_id': serializer.toJson<String?>(nativeCoinId),
      'date_confirmed': serializer.toJson<DateTime?>(dateConfirmed),
      'date_requested': serializer.toJson<DateTime?>(dateRequested),
      'created_at_in_relay': serializer.toJson<DateTime?>(createdAtInRelay),
      'user_pubkey': serializer.toJson<String?>(userPubkey),
      'asset_id': serializer.toJson<String?>(assetId),
      'transferred_amount': serializer.toJson<String?>(transferredAmount),
      'transferred_amount_usd':
          serializer.toJson<double?>(transferredAmountUsd),
      'balance_before_transfer':
          serializer.toJson<String?>(balanceBeforeTransfer),
    };
  }

  TransactionsTableData copyWith(
          {String? type,
          String? txHash,
          String? networkId,
          Value<String?> coinId = const Value.absent(),
          String? senderWalletAddress,
          String? receiverWalletAddress,
          Value<String?> id = const Value.absent(),
          Value<String?> fee = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> nativeCoinId = const Value.absent(),
          Value<DateTime?> dateConfirmed = const Value.absent(),
          Value<DateTime?> dateRequested = const Value.absent(),
          Value<DateTime?> createdAtInRelay = const Value.absent(),
          Value<String?> userPubkey = const Value.absent(),
          Value<String?> assetId = const Value.absent(),
          Value<String?> transferredAmount = const Value.absent(),
          Value<double?> transferredAmountUsd = const Value.absent(),
          Value<String?> balanceBeforeTransfer = const Value.absent()}) =>
      TransactionsTableData(
        type: type ?? this.type,
        txHash: txHash ?? this.txHash,
        networkId: networkId ?? this.networkId,
        coinId: coinId.present ? coinId.value : this.coinId,
        senderWalletAddress: senderWalletAddress ?? this.senderWalletAddress,
        receiverWalletAddress:
            receiverWalletAddress ?? this.receiverWalletAddress,
        id: id.present ? id.value : this.id,
        fee: fee.present ? fee.value : this.fee,
        status: status.present ? status.value : this.status,
        nativeCoinId:
            nativeCoinId.present ? nativeCoinId.value : this.nativeCoinId,
        dateConfirmed:
            dateConfirmed.present ? dateConfirmed.value : this.dateConfirmed,
        dateRequested:
            dateRequested.present ? dateRequested.value : this.dateRequested,
        createdAtInRelay: createdAtInRelay.present
            ? createdAtInRelay.value
            : this.createdAtInRelay,
        userPubkey: userPubkey.present ? userPubkey.value : this.userPubkey,
        assetId: assetId.present ? assetId.value : this.assetId,
        transferredAmount: transferredAmount.present
            ? transferredAmount.value
            : this.transferredAmount,
        transferredAmountUsd: transferredAmountUsd.present
            ? transferredAmountUsd.value
            : this.transferredAmountUsd,
        balanceBeforeTransfer: balanceBeforeTransfer.present
            ? balanceBeforeTransfer.value
            : this.balanceBeforeTransfer,
      );
  TransactionsTableData copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionsTableData(
      type: data.type.present ? data.type.value : this.type,
      txHash: data.txHash.present ? data.txHash.value : this.txHash,
      networkId: data.networkId.present ? data.networkId.value : this.networkId,
      coinId: data.coinId.present ? data.coinId.value : this.coinId,
      senderWalletAddress: data.senderWalletAddress.present
          ? data.senderWalletAddress.value
          : this.senderWalletAddress,
      receiverWalletAddress: data.receiverWalletAddress.present
          ? data.receiverWalletAddress.value
          : this.receiverWalletAddress,
      id: data.id.present ? data.id.value : this.id,
      fee: data.fee.present ? data.fee.value : this.fee,
      status: data.status.present ? data.status.value : this.status,
      nativeCoinId: data.nativeCoinId.present
          ? data.nativeCoinId.value
          : this.nativeCoinId,
      dateConfirmed: data.dateConfirmed.present
          ? data.dateConfirmed.value
          : this.dateConfirmed,
      dateRequested: data.dateRequested.present
          ? data.dateRequested.value
          : this.dateRequested,
      createdAtInRelay: data.createdAtInRelay.present
          ? data.createdAtInRelay.value
          : this.createdAtInRelay,
      userPubkey:
          data.userPubkey.present ? data.userPubkey.value : this.userPubkey,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      transferredAmount: data.transferredAmount.present
          ? data.transferredAmount.value
          : this.transferredAmount,
      transferredAmountUsd: data.transferredAmountUsd.present
          ? data.transferredAmountUsd.value
          : this.transferredAmountUsd,
      balanceBeforeTransfer: data.balanceBeforeTransfer.present
          ? data.balanceBeforeTransfer.value
          : this.balanceBeforeTransfer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableData(')
          ..write('type: $type, ')
          ..write('txHash: $txHash, ')
          ..write('networkId: $networkId, ')
          ..write('coinId: $coinId, ')
          ..write('senderWalletAddress: $senderWalletAddress, ')
          ..write('receiverWalletAddress: $receiverWalletAddress, ')
          ..write('id: $id, ')
          ..write('fee: $fee, ')
          ..write('status: $status, ')
          ..write('nativeCoinId: $nativeCoinId, ')
          ..write('dateConfirmed: $dateConfirmed, ')
          ..write('dateRequested: $dateRequested, ')
          ..write('createdAtInRelay: $createdAtInRelay, ')
          ..write('userPubkey: $userPubkey, ')
          ..write('assetId: $assetId, ')
          ..write('transferredAmount: $transferredAmount, ')
          ..write('transferredAmountUsd: $transferredAmountUsd, ')
          ..write('balanceBeforeTransfer: $balanceBeforeTransfer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      type,
      txHash,
      networkId,
      coinId,
      senderWalletAddress,
      receiverWalletAddress,
      id,
      fee,
      status,
      nativeCoinId,
      dateConfirmed,
      dateRequested,
      createdAtInRelay,
      userPubkey,
      assetId,
      transferredAmount,
      transferredAmountUsd,
      balanceBeforeTransfer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsTableData &&
          other.type == this.type &&
          other.txHash == this.txHash &&
          other.networkId == this.networkId &&
          other.coinId == this.coinId &&
          other.senderWalletAddress == this.senderWalletAddress &&
          other.receiverWalletAddress == this.receiverWalletAddress &&
          other.id == this.id &&
          other.fee == this.fee &&
          other.status == this.status &&
          other.nativeCoinId == this.nativeCoinId &&
          other.dateConfirmed == this.dateConfirmed &&
          other.dateRequested == this.dateRequested &&
          other.createdAtInRelay == this.createdAtInRelay &&
          other.userPubkey == this.userPubkey &&
          other.assetId == this.assetId &&
          other.transferredAmount == this.transferredAmount &&
          other.transferredAmountUsd == this.transferredAmountUsd &&
          other.balanceBeforeTransfer == this.balanceBeforeTransfer);
}

class TransactionsTableCompanion
    extends UpdateCompanion<TransactionsTableData> {
  final Value<String> type;
  final Value<String> txHash;
  final Value<String> networkId;
  final Value<String?> coinId;
  final Value<String> senderWalletAddress;
  final Value<String> receiverWalletAddress;
  final Value<String?> id;
  final Value<String?> fee;
  final Value<String?> status;
  final Value<String?> nativeCoinId;
  final Value<DateTime?> dateConfirmed;
  final Value<DateTime?> dateRequested;
  final Value<DateTime?> createdAtInRelay;
  final Value<String?> userPubkey;
  final Value<String?> assetId;
  final Value<String?> transferredAmount;
  final Value<double?> transferredAmountUsd;
  final Value<String?> balanceBeforeTransfer;
  final Value<int> rowid;
  const TransactionsTableCompanion({
    this.type = const Value.absent(),
    this.txHash = const Value.absent(),
    this.networkId = const Value.absent(),
    this.coinId = const Value.absent(),
    this.senderWalletAddress = const Value.absent(),
    this.receiverWalletAddress = const Value.absent(),
    this.id = const Value.absent(),
    this.fee = const Value.absent(),
    this.status = const Value.absent(),
    this.nativeCoinId = const Value.absent(),
    this.dateConfirmed = const Value.absent(),
    this.dateRequested = const Value.absent(),
    this.createdAtInRelay = const Value.absent(),
    this.userPubkey = const Value.absent(),
    this.assetId = const Value.absent(),
    this.transferredAmount = const Value.absent(),
    this.transferredAmountUsd = const Value.absent(),
    this.balanceBeforeTransfer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    required String type,
    required String txHash,
    required String networkId,
    this.coinId = const Value.absent(),
    required String senderWalletAddress,
    required String receiverWalletAddress,
    this.id = const Value.absent(),
    this.fee = const Value.absent(),
    this.status = const Value.absent(),
    this.nativeCoinId = const Value.absent(),
    this.dateConfirmed = const Value.absent(),
    this.dateRequested = const Value.absent(),
    this.createdAtInRelay = const Value.absent(),
    this.userPubkey = const Value.absent(),
    this.assetId = const Value.absent(),
    this.transferredAmount = const Value.absent(),
    this.transferredAmountUsd = const Value.absent(),
    this.balanceBeforeTransfer = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : type = Value(type),
        txHash = Value(txHash),
        networkId = Value(networkId),
        senderWalletAddress = Value(senderWalletAddress),
        receiverWalletAddress = Value(receiverWalletAddress);
  static Insertable<TransactionsTableData> custom({
    Expression<String>? type,
    Expression<String>? txHash,
    Expression<String>? networkId,
    Expression<String>? coinId,
    Expression<String>? senderWalletAddress,
    Expression<String>? receiverWalletAddress,
    Expression<String>? id,
    Expression<String>? fee,
    Expression<String>? status,
    Expression<String>? nativeCoinId,
    Expression<DateTime>? dateConfirmed,
    Expression<DateTime>? dateRequested,
    Expression<DateTime>? createdAtInRelay,
    Expression<String>? userPubkey,
    Expression<String>? assetId,
    Expression<String>? transferredAmount,
    Expression<double>? transferredAmountUsd,
    Expression<String>? balanceBeforeTransfer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (type != null) 'type': type,
      if (txHash != null) 'tx_hash': txHash,
      if (networkId != null) 'network_id': networkId,
      if (coinId != null) 'coin_id': coinId,
      if (senderWalletAddress != null)
        'sender_wallet_address': senderWalletAddress,
      if (receiverWalletAddress != null)
        'receiver_wallet_address': receiverWalletAddress,
      if (id != null) 'id': id,
      if (fee != null) 'fee': fee,
      if (status != null) 'status': status,
      if (nativeCoinId != null) 'native_coin_id': nativeCoinId,
      if (dateConfirmed != null) 'date_confirmed': dateConfirmed,
      if (dateRequested != null) 'date_requested': dateRequested,
      if (createdAtInRelay != null) 'created_at_in_relay': createdAtInRelay,
      if (userPubkey != null) 'user_pubkey': userPubkey,
      if (assetId != null) 'asset_id': assetId,
      if (transferredAmount != null) 'transferred_amount': transferredAmount,
      if (transferredAmountUsd != null)
        'transferred_amount_usd': transferredAmountUsd,
      if (balanceBeforeTransfer != null)
        'balance_before_transfer': balanceBeforeTransfer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsTableCompanion copyWith(
      {Value<String>? type,
      Value<String>? txHash,
      Value<String>? networkId,
      Value<String?>? coinId,
      Value<String>? senderWalletAddress,
      Value<String>? receiverWalletAddress,
      Value<String?>? id,
      Value<String?>? fee,
      Value<String?>? status,
      Value<String?>? nativeCoinId,
      Value<DateTime?>? dateConfirmed,
      Value<DateTime?>? dateRequested,
      Value<DateTime?>? createdAtInRelay,
      Value<String?>? userPubkey,
      Value<String?>? assetId,
      Value<String?>? transferredAmount,
      Value<double?>? transferredAmountUsd,
      Value<String?>? balanceBeforeTransfer,
      Value<int>? rowid}) {
    return TransactionsTableCompanion(
      type: type ?? this.type,
      txHash: txHash ?? this.txHash,
      networkId: networkId ?? this.networkId,
      coinId: coinId ?? this.coinId,
      senderWalletAddress: senderWalletAddress ?? this.senderWalletAddress,
      receiverWalletAddress:
          receiverWalletAddress ?? this.receiverWalletAddress,
      id: id ?? this.id,
      fee: fee ?? this.fee,
      status: status ?? this.status,
      nativeCoinId: nativeCoinId ?? this.nativeCoinId,
      dateConfirmed: dateConfirmed ?? this.dateConfirmed,
      dateRequested: dateRequested ?? this.dateRequested,
      createdAtInRelay: createdAtInRelay ?? this.createdAtInRelay,
      userPubkey: userPubkey ?? this.userPubkey,
      assetId: assetId ?? this.assetId,
      transferredAmount: transferredAmount ?? this.transferredAmount,
      transferredAmountUsd: transferredAmountUsd ?? this.transferredAmountUsd,
      balanceBeforeTransfer:
          balanceBeforeTransfer ?? this.balanceBeforeTransfer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (txHash.present) {
      map['tx_hash'] = Variable<String>(txHash.value);
    }
    if (networkId.present) {
      map['network_id'] = Variable<String>(networkId.value);
    }
    if (coinId.present) {
      map['coin_id'] = Variable<String>(coinId.value);
    }
    if (senderWalletAddress.present) {
      map['sender_wallet_address'] =
          Variable<String>(senderWalletAddress.value);
    }
    if (receiverWalletAddress.present) {
      map['receiver_wallet_address'] =
          Variable<String>(receiverWalletAddress.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fee.present) {
      map['fee'] = Variable<String>(fee.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (nativeCoinId.present) {
      map['native_coin_id'] = Variable<String>(nativeCoinId.value);
    }
    if (dateConfirmed.present) {
      map['date_confirmed'] = Variable<DateTime>(dateConfirmed.value);
    }
    if (dateRequested.present) {
      map['date_requested'] = Variable<DateTime>(dateRequested.value);
    }
    if (createdAtInRelay.present) {
      map['created_at_in_relay'] = Variable<DateTime>(createdAtInRelay.value);
    }
    if (userPubkey.present) {
      map['user_pubkey'] = Variable<String>(userPubkey.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (transferredAmount.present) {
      map['transferred_amount'] = Variable<String>(transferredAmount.value);
    }
    if (transferredAmountUsd.present) {
      map['transferred_amount_usd'] =
          Variable<double>(transferredAmountUsd.value);
    }
    if (balanceBeforeTransfer.present) {
      map['balance_before_transfer'] =
          Variable<String>(balanceBeforeTransfer.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('type: $type, ')
          ..write('txHash: $txHash, ')
          ..write('networkId: $networkId, ')
          ..write('coinId: $coinId, ')
          ..write('senderWalletAddress: $senderWalletAddress, ')
          ..write('receiverWalletAddress: $receiverWalletAddress, ')
          ..write('id: $id, ')
          ..write('fee: $fee, ')
          ..write('status: $status, ')
          ..write('nativeCoinId: $nativeCoinId, ')
          ..write('dateConfirmed: $dateConfirmed, ')
          ..write('dateRequested: $dateRequested, ')
          ..write('createdAtInRelay: $createdAtInRelay, ')
          ..write('userPubkey: $userPubkey, ')
          ..write('assetId: $assetId, ')
          ..write('transferredAmount: $transferredAmount, ')
          ..write('transferredAmountUsd: $transferredAmountUsd, ')
          ..write('balanceBeforeTransfer: $balanceBeforeTransfer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class CryptoWalletsTable extends Table
    with TableInfo<CryptoWalletsTable, CryptoWalletsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CryptoWalletsTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> networkId = GeneratedColumn<String>(
      'network_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> isHistoryLoaded = GeneratedColumn<bool>(
      'is_history_loaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_history_loaded" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, address, networkId, isHistoryLoaded];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crypto_wallets_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CryptoWalletsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CryptoWalletsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      networkId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}network_id'])!,
      isHistoryLoaded: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_history_loaded'])!,
    );
  }

  @override
  CryptoWalletsTable createAlias(String alias) {
    return CryptoWalletsTable(attachedDatabase, alias);
  }
}

class CryptoWalletsTableData extends DataClass
    implements Insertable<CryptoWalletsTableData> {
  final String id;
  final String address;
  final String networkId;
  final bool isHistoryLoaded;
  const CryptoWalletsTableData(
      {required this.id,
      required this.address,
      required this.networkId,
      required this.isHistoryLoaded});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['address'] = Variable<String>(address);
    map['network_id'] = Variable<String>(networkId);
    map['is_history_loaded'] = Variable<bool>(isHistoryLoaded);
    return map;
  }

  CryptoWalletsTableCompanion toCompanion(bool nullToAbsent) {
    return CryptoWalletsTableCompanion(
      id: Value(id),
      address: Value(address),
      networkId: Value(networkId),
      isHistoryLoaded: Value(isHistoryLoaded),
    );
  }

  factory CryptoWalletsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CryptoWalletsTableData(
      id: serializer.fromJson<String>(json['id']),
      address: serializer.fromJson<String>(json['address']),
      networkId: serializer.fromJson<String>(json['network_id']),
      isHistoryLoaded: serializer.fromJson<bool>(json['is_history_loaded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'address': serializer.toJson<String>(address),
      'network_id': serializer.toJson<String>(networkId),
      'is_history_loaded': serializer.toJson<bool>(isHistoryLoaded),
    };
  }

  CryptoWalletsTableData copyWith(
          {String? id,
          String? address,
          String? networkId,
          bool? isHistoryLoaded}) =>
      CryptoWalletsTableData(
        id: id ?? this.id,
        address: address ?? this.address,
        networkId: networkId ?? this.networkId,
        isHistoryLoaded: isHistoryLoaded ?? this.isHistoryLoaded,
      );
  CryptoWalletsTableData copyWithCompanion(CryptoWalletsTableCompanion data) {
    return CryptoWalletsTableData(
      id: data.id.present ? data.id.value : this.id,
      address: data.address.present ? data.address.value : this.address,
      networkId: data.networkId.present ? data.networkId.value : this.networkId,
      isHistoryLoaded: data.isHistoryLoaded.present
          ? data.isHistoryLoaded.value
          : this.isHistoryLoaded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CryptoWalletsTableData(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('networkId: $networkId, ')
          ..write('isHistoryLoaded: $isHistoryLoaded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, address, networkId, isHistoryLoaded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CryptoWalletsTableData &&
          other.id == this.id &&
          other.address == this.address &&
          other.networkId == this.networkId &&
          other.isHistoryLoaded == this.isHistoryLoaded);
}

class CryptoWalletsTableCompanion
    extends UpdateCompanion<CryptoWalletsTableData> {
  final Value<String> id;
  final Value<String> address;
  final Value<String> networkId;
  final Value<bool> isHistoryLoaded;
  final Value<int> rowid;
  const CryptoWalletsTableCompanion({
    this.id = const Value.absent(),
    this.address = const Value.absent(),
    this.networkId = const Value.absent(),
    this.isHistoryLoaded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CryptoWalletsTableCompanion.insert({
    required String id,
    required String address,
    required String networkId,
    this.isHistoryLoaded = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        address = Value(address),
        networkId = Value(networkId);
  static Insertable<CryptoWalletsTableData> custom({
    Expression<String>? id,
    Expression<String>? address,
    Expression<String>? networkId,
    Expression<bool>? isHistoryLoaded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (address != null) 'address': address,
      if (networkId != null) 'network_id': networkId,
      if (isHistoryLoaded != null) 'is_history_loaded': isHistoryLoaded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CryptoWalletsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? address,
      Value<String>? networkId,
      Value<bool>? isHistoryLoaded,
      Value<int>? rowid}) {
    return CryptoWalletsTableCompanion(
      id: id ?? this.id,
      address: address ?? this.address,
      networkId: networkId ?? this.networkId,
      isHistoryLoaded: isHistoryLoaded ?? this.isHistoryLoaded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (networkId.present) {
      map['network_id'] = Variable<String>(networkId.value);
    }
    if (isHistoryLoaded.present) {
      map['is_history_loaded'] = Variable<bool>(isHistoryLoaded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CryptoWalletsTableCompanion(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('networkId: $networkId, ')
          ..write('isHistoryLoaded: $isHistoryLoaded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class RequestAssetsTable extends Table
    with TableInfo<RequestAssetsTable, RequestAssetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  RequestAssetsTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
      'event_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> pubkey = GeneratedColumn<String>(
      'pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<String> networkId = GeneratedColumn<String>(
      'network_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> assetClass = GeneratedColumn<String>(
      'asset_class', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> assetAddress = GeneratedColumn<String>(
      'asset_address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> from = GeneratedColumn<String>(
      'from', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> to = GeneratedColumn<String>(
      'to', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> walletAddress = GeneratedColumn<String>(
      'wallet_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> userPubkey = GeneratedColumn<String>(
      'user_pubkey', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
      'asset_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
      'amount', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> amountUsd = GeneratedColumn<String>(
      'amount_usd', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<bool> isPending = GeneratedColumn<bool>(
      'is_pending', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_pending" IN (0, 1))'),
      defaultValue: const CustomExpression('1'));
  late final GeneratedColumn<String> request = GeneratedColumn<String>(
      'request', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        eventId,
        pubkey,
        createdAt,
        networkId,
        assetClass,
        assetAddress,
        from,
        to,
        walletAddress,
        userPubkey,
        assetId,
        amount,
        amountUsd,
        isPending,
        request
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'request_assets_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RequestAssetsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RequestAssetsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      eventId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_id'])!,
      pubkey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pubkey'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      networkId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}network_id'])!,
      assetClass: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_class'])!,
      assetAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_address'])!,
      from: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from'])!,
      to: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to'])!,
      walletAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}wallet_address']),
      userPubkey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_pubkey']),
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_id']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount']),
      amountUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount_usd']),
      isPending: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_pending'])!,
      request: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}request']),
    );
  }

  @override
  RequestAssetsTable createAlias(String alias) {
    return RequestAssetsTable(attachedDatabase, alias);
  }
}

class RequestAssetsTableData extends DataClass
    implements Insertable<RequestAssetsTableData> {
  final int id;
  final String eventId;
  final String pubkey;
  final DateTime createdAt;
  final String networkId;
  final String assetClass;
  final String assetAddress;
  final String from;
  final String to;
  final String? walletAddress;
  final String? userPubkey;
  final String? assetId;
  final String? amount;
  final String? amountUsd;
  final bool isPending;
  final String? request;
  const RequestAssetsTableData(
      {required this.id,
      required this.eventId,
      required this.pubkey,
      required this.createdAt,
      required this.networkId,
      required this.assetClass,
      required this.assetAddress,
      required this.from,
      required this.to,
      this.walletAddress,
      this.userPubkey,
      this.assetId,
      this.amount,
      this.amountUsd,
      required this.isPending,
      this.request});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<String>(eventId);
    map['pubkey'] = Variable<String>(pubkey);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['network_id'] = Variable<String>(networkId);
    map['asset_class'] = Variable<String>(assetClass);
    map['asset_address'] = Variable<String>(assetAddress);
    map['from'] = Variable<String>(from);
    map['to'] = Variable<String>(to);
    if (!nullToAbsent || walletAddress != null) {
      map['wallet_address'] = Variable<String>(walletAddress);
    }
    if (!nullToAbsent || userPubkey != null) {
      map['user_pubkey'] = Variable<String>(userPubkey);
    }
    if (!nullToAbsent || assetId != null) {
      map['asset_id'] = Variable<String>(assetId);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<String>(amount);
    }
    if (!nullToAbsent || amountUsd != null) {
      map['amount_usd'] = Variable<String>(amountUsd);
    }
    map['is_pending'] = Variable<bool>(isPending);
    if (!nullToAbsent || request != null) {
      map['request'] = Variable<String>(request);
    }
    return map;
  }

  RequestAssetsTableCompanion toCompanion(bool nullToAbsent) {
    return RequestAssetsTableCompanion(
      id: Value(id),
      eventId: Value(eventId),
      pubkey: Value(pubkey),
      createdAt: Value(createdAt),
      networkId: Value(networkId),
      assetClass: Value(assetClass),
      assetAddress: Value(assetAddress),
      from: Value(from),
      to: Value(to),
      walletAddress: walletAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(walletAddress),
      userPubkey: userPubkey == null && nullToAbsent
          ? const Value.absent()
          : Value(userPubkey),
      assetId: assetId == null && nullToAbsent
          ? const Value.absent()
          : Value(assetId),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      amountUsd: amountUsd == null && nullToAbsent
          ? const Value.absent()
          : Value(amountUsd),
      isPending: Value(isPending),
      request: request == null && nullToAbsent
          ? const Value.absent()
          : Value(request),
    );
  }

  factory RequestAssetsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RequestAssetsTableData(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<String>(json['event_id']),
      pubkey: serializer.fromJson<String>(json['pubkey']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      networkId: serializer.fromJson<String>(json['network_id']),
      assetClass: serializer.fromJson<String>(json['asset_class']),
      assetAddress: serializer.fromJson<String>(json['asset_address']),
      from: serializer.fromJson<String>(json['from']),
      to: serializer.fromJson<String>(json['to']),
      walletAddress: serializer.fromJson<String?>(json['wallet_address']),
      userPubkey: serializer.fromJson<String?>(json['user_pubkey']),
      assetId: serializer.fromJson<String?>(json['asset_id']),
      amount: serializer.fromJson<String?>(json['amount']),
      amountUsd: serializer.fromJson<String?>(json['amount_usd']),
      isPending: serializer.fromJson<bool>(json['is_pending']),
      request: serializer.fromJson<String?>(json['request']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'event_id': serializer.toJson<String>(eventId),
      'pubkey': serializer.toJson<String>(pubkey),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'network_id': serializer.toJson<String>(networkId),
      'asset_class': serializer.toJson<String>(assetClass),
      'asset_address': serializer.toJson<String>(assetAddress),
      'from': serializer.toJson<String>(from),
      'to': serializer.toJson<String>(to),
      'wallet_address': serializer.toJson<String?>(walletAddress),
      'user_pubkey': serializer.toJson<String?>(userPubkey),
      'asset_id': serializer.toJson<String?>(assetId),
      'amount': serializer.toJson<String?>(amount),
      'amount_usd': serializer.toJson<String?>(amountUsd),
      'is_pending': serializer.toJson<bool>(isPending),
      'request': serializer.toJson<String?>(request),
    };
  }

  RequestAssetsTableData copyWith(
          {int? id,
          String? eventId,
          String? pubkey,
          DateTime? createdAt,
          String? networkId,
          String? assetClass,
          String? assetAddress,
          String? from,
          String? to,
          Value<String?> walletAddress = const Value.absent(),
          Value<String?> userPubkey = const Value.absent(),
          Value<String?> assetId = const Value.absent(),
          Value<String?> amount = const Value.absent(),
          Value<String?> amountUsd = const Value.absent(),
          bool? isPending,
          Value<String?> request = const Value.absent()}) =>
      RequestAssetsTableData(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        pubkey: pubkey ?? this.pubkey,
        createdAt: createdAt ?? this.createdAt,
        networkId: networkId ?? this.networkId,
        assetClass: assetClass ?? this.assetClass,
        assetAddress: assetAddress ?? this.assetAddress,
        from: from ?? this.from,
        to: to ?? this.to,
        walletAddress:
            walletAddress.present ? walletAddress.value : this.walletAddress,
        userPubkey: userPubkey.present ? userPubkey.value : this.userPubkey,
        assetId: assetId.present ? assetId.value : this.assetId,
        amount: amount.present ? amount.value : this.amount,
        amountUsd: amountUsd.present ? amountUsd.value : this.amountUsd,
        isPending: isPending ?? this.isPending,
        request: request.present ? request.value : this.request,
      );
  RequestAssetsTableData copyWithCompanion(RequestAssetsTableCompanion data) {
    return RequestAssetsTableData(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      pubkey: data.pubkey.present ? data.pubkey.value : this.pubkey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      networkId: data.networkId.present ? data.networkId.value : this.networkId,
      assetClass:
          data.assetClass.present ? data.assetClass.value : this.assetClass,
      assetAddress: data.assetAddress.present
          ? data.assetAddress.value
          : this.assetAddress,
      from: data.from.present ? data.from.value : this.from,
      to: data.to.present ? data.to.value : this.to,
      walletAddress: data.walletAddress.present
          ? data.walletAddress.value
          : this.walletAddress,
      userPubkey:
          data.userPubkey.present ? data.userPubkey.value : this.userPubkey,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      amount: data.amount.present ? data.amount.value : this.amount,
      amountUsd: data.amountUsd.present ? data.amountUsd.value : this.amountUsd,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
      request: data.request.present ? data.request.value : this.request,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RequestAssetsTableData(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('pubkey: $pubkey, ')
          ..write('createdAt: $createdAt, ')
          ..write('networkId: $networkId, ')
          ..write('assetClass: $assetClass, ')
          ..write('assetAddress: $assetAddress, ')
          ..write('from: $from, ')
          ..write('to: $to, ')
          ..write('walletAddress: $walletAddress, ')
          ..write('userPubkey: $userPubkey, ')
          ..write('assetId: $assetId, ')
          ..write('amount: $amount, ')
          ..write('amountUsd: $amountUsd, ')
          ..write('isPending: $isPending, ')
          ..write('request: $request')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      eventId,
      pubkey,
      createdAt,
      networkId,
      assetClass,
      assetAddress,
      from,
      to,
      walletAddress,
      userPubkey,
      assetId,
      amount,
      amountUsd,
      isPending,
      request);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestAssetsTableData &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.pubkey == this.pubkey &&
          other.createdAt == this.createdAt &&
          other.networkId == this.networkId &&
          other.assetClass == this.assetClass &&
          other.assetAddress == this.assetAddress &&
          other.from == this.from &&
          other.to == this.to &&
          other.walletAddress == this.walletAddress &&
          other.userPubkey == this.userPubkey &&
          other.assetId == this.assetId &&
          other.amount == this.amount &&
          other.amountUsd == this.amountUsd &&
          other.isPending == this.isPending &&
          other.request == this.request);
}

class RequestAssetsTableCompanion
    extends UpdateCompanion<RequestAssetsTableData> {
  final Value<int> id;
  final Value<String> eventId;
  final Value<String> pubkey;
  final Value<DateTime> createdAt;
  final Value<String> networkId;
  final Value<String> assetClass;
  final Value<String> assetAddress;
  final Value<String> from;
  final Value<String> to;
  final Value<String?> walletAddress;
  final Value<String?> userPubkey;
  final Value<String?> assetId;
  final Value<String?> amount;
  final Value<String?> amountUsd;
  final Value<bool> isPending;
  final Value<String?> request;
  const RequestAssetsTableCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.pubkey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.networkId = const Value.absent(),
    this.assetClass = const Value.absent(),
    this.assetAddress = const Value.absent(),
    this.from = const Value.absent(),
    this.to = const Value.absent(),
    this.walletAddress = const Value.absent(),
    this.userPubkey = const Value.absent(),
    this.assetId = const Value.absent(),
    this.amount = const Value.absent(),
    this.amountUsd = const Value.absent(),
    this.isPending = const Value.absent(),
    this.request = const Value.absent(),
  });
  RequestAssetsTableCompanion.insert({
    this.id = const Value.absent(),
    required String eventId,
    required String pubkey,
    required DateTime createdAt,
    required String networkId,
    required String assetClass,
    required String assetAddress,
    required String from,
    required String to,
    this.walletAddress = const Value.absent(),
    this.userPubkey = const Value.absent(),
    this.assetId = const Value.absent(),
    this.amount = const Value.absent(),
    this.amountUsd = const Value.absent(),
    this.isPending = const Value.absent(),
    this.request = const Value.absent(),
  })  : eventId = Value(eventId),
        pubkey = Value(pubkey),
        createdAt = Value(createdAt),
        networkId = Value(networkId),
        assetClass = Value(assetClass),
        assetAddress = Value(assetAddress),
        from = Value(from),
        to = Value(to);
  static Insertable<RequestAssetsTableData> custom({
    Expression<int>? id,
    Expression<String>? eventId,
    Expression<String>? pubkey,
    Expression<DateTime>? createdAt,
    Expression<String>? networkId,
    Expression<String>? assetClass,
    Expression<String>? assetAddress,
    Expression<String>? from,
    Expression<String>? to,
    Expression<String>? walletAddress,
    Expression<String>? userPubkey,
    Expression<String>? assetId,
    Expression<String>? amount,
    Expression<String>? amountUsd,
    Expression<bool>? isPending,
    Expression<String>? request,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (pubkey != null) 'pubkey': pubkey,
      if (createdAt != null) 'created_at': createdAt,
      if (networkId != null) 'network_id': networkId,
      if (assetClass != null) 'asset_class': assetClass,
      if (assetAddress != null) 'asset_address': assetAddress,
      if (from != null) 'from': from,
      if (to != null) 'to': to,
      if (walletAddress != null) 'wallet_address': walletAddress,
      if (userPubkey != null) 'user_pubkey': userPubkey,
      if (assetId != null) 'asset_id': assetId,
      if (amount != null) 'amount': amount,
      if (amountUsd != null) 'amount_usd': amountUsd,
      if (isPending != null) 'is_pending': isPending,
      if (request != null) 'request': request,
    });
  }

  RequestAssetsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? eventId,
      Value<String>? pubkey,
      Value<DateTime>? createdAt,
      Value<String>? networkId,
      Value<String>? assetClass,
      Value<String>? assetAddress,
      Value<String>? from,
      Value<String>? to,
      Value<String?>? walletAddress,
      Value<String?>? userPubkey,
      Value<String?>? assetId,
      Value<String?>? amount,
      Value<String?>? amountUsd,
      Value<bool>? isPending,
      Value<String?>? request}) {
    return RequestAssetsTableCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      pubkey: pubkey ?? this.pubkey,
      createdAt: createdAt ?? this.createdAt,
      networkId: networkId ?? this.networkId,
      assetClass: assetClass ?? this.assetClass,
      assetAddress: assetAddress ?? this.assetAddress,
      from: from ?? this.from,
      to: to ?? this.to,
      walletAddress: walletAddress ?? this.walletAddress,
      userPubkey: userPubkey ?? this.userPubkey,
      assetId: assetId ?? this.assetId,
      amount: amount ?? this.amount,
      amountUsd: amountUsd ?? this.amountUsd,
      isPending: isPending ?? this.isPending,
      request: request ?? this.request,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (pubkey.present) {
      map['pubkey'] = Variable<String>(pubkey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (networkId.present) {
      map['network_id'] = Variable<String>(networkId.value);
    }
    if (assetClass.present) {
      map['asset_class'] = Variable<String>(assetClass.value);
    }
    if (assetAddress.present) {
      map['asset_address'] = Variable<String>(assetAddress.value);
    }
    if (from.present) {
      map['from'] = Variable<String>(from.value);
    }
    if (to.present) {
      map['to'] = Variable<String>(to.value);
    }
    if (walletAddress.present) {
      map['wallet_address'] = Variable<String>(walletAddress.value);
    }
    if (userPubkey.present) {
      map['user_pubkey'] = Variable<String>(userPubkey.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (amountUsd.present) {
      map['amount_usd'] = Variable<String>(amountUsd.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<bool>(isPending.value);
    }
    if (request.present) {
      map['request'] = Variable<String>(request.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequestAssetsTableCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('pubkey: $pubkey, ')
          ..write('createdAt: $createdAt, ')
          ..write('networkId: $networkId, ')
          ..write('assetClass: $assetClass, ')
          ..write('assetAddress: $assetAddress, ')
          ..write('from: $from, ')
          ..write('to: $to, ')
          ..write('walletAddress: $walletAddress, ')
          ..write('userPubkey: $userPubkey, ')
          ..write('assetId: $assetId, ')
          ..write('amount: $amount, ')
          ..write('amountUsd: $amountUsd, ')
          ..write('isPending: $isPending, ')
          ..write('request: $request')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final CoinsTable coinsTable = CoinsTable(this);
  late final SyncCoinsTable syncCoinsTable = SyncCoinsTable(this);
  late final NetworksTable networksTable = NetworksTable(this);
  late final TransactionsTable transactionsTable = TransactionsTable(this);
  late final CryptoWalletsTable cryptoWalletsTable = CryptoWalletsTable(this);
  late final RequestAssetsTable requestAssetsTable = RequestAssetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        coinsTable,
        syncCoinsTable,
        networksTable,
        transactionsTable,
        cryptoWalletsTable,
        requestAssetsTable
      ];
  @override
  int get schemaVersion => 2;
}
