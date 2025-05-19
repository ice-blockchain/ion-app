// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_asset.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletAssetNativeImpl _$$WalletAssetNativeImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletAssetNativeImpl(
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      balance: const StringOrIntConverter().fromJson(json['balance']),
      kind: json['kind'] as String,
      verified: json['verified'] as bool?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$WalletAssetNativeImplToJson(
        _$WalletAssetNativeImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'balance': const StringOrIntConverter().toJson(instance.balance),
      'kind': instance.kind,
      'verified': instance.verified,
      'name': instance.name,
    };

_$WalletAssetErc20Impl _$$WalletAssetErc20ImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletAssetErc20Impl(
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      balance: const StringOrIntConverter().fromJson(json['balance']),
      kind: json['kind'] as String,
      verified: json['verified'] as bool?,
      contract: json['contract'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$WalletAssetErc20ImplToJson(
        _$WalletAssetErc20Impl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'balance': const StringOrIntConverter().toJson(instance.balance),
      'kind': instance.kind,
      'verified': instance.verified,
      'contract': instance.contract,
      'name': instance.name,
    };

_$WalletAssetAsaImpl _$$WalletAssetAsaImplFromJson(Map<String, dynamic> json) =>
    _$WalletAssetAsaImpl(
      assetId: json['assetId'] as String,
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      verified: json['verified'] as bool,
      balance: const StringOrIntConverter().fromJson(json['balance']),
      kind: json['kind'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$WalletAssetAsaImplToJson(
        _$WalletAssetAsaImpl instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'verified': instance.verified,
      'balance': const StringOrIntConverter().toJson(instance.balance),
      'kind': instance.kind,
      'name': instance.name,
    };

_$WalletAssetSplImpl _$$WalletAssetSplImplFromJson(Map<String, dynamic> json) =>
    _$WalletAssetSplImpl(
      mint: json['mint'] as String,
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      balance: const StringOrIntConverter().fromJson(json['balance']),
      kind: json['kind'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$WalletAssetSplImplToJson(
        _$WalletAssetSplImpl instance) =>
    <String, dynamic>{
      'mint': instance.mint,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'balance': const StringOrIntConverter().toJson(instance.balance),
      'kind': instance.kind,
      'name': instance.name,
    };

_$WalletAssetSpl2022Impl _$$WalletAssetSpl2022ImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletAssetSpl2022Impl(
      mint: json['mint'] as String,
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      balance: const StringOrIntConverter().fromJson(json['balance']),
      kind: json['kind'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$WalletAssetSpl2022ImplToJson(
        _$WalletAssetSpl2022Impl instance) =>
    <String, dynamic>{
      'mint': instance.mint,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'balance': const StringOrIntConverter().toJson(instance.balance),
      'kind': instance.kind,
      'name': instance.name,
    };

_$WalletAssetSep41Impl _$$WalletAssetSep41ImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletAssetSep41Impl(
      mint: json['mint'] as String,
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      balance: const StringOrIntConverter().fromJson(json['balance']),
      kind: json['kind'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$WalletAssetSep41ImplToJson(
        _$WalletAssetSep41Impl instance) =>
    <String, dynamic>{
      'mint': instance.mint,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'balance': const StringOrIntConverter().toJson(instance.balance),
      'kind': instance.kind,
      'name': instance.name,
    };

_$WalletAssetTep74Impl _$$WalletAssetTep74ImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletAssetTep74Impl(
      mint: json['mint'] as String,
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      balance: const StringOrIntConverter().fromJson(json['balance']),
      kind: json['kind'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$WalletAssetTep74ImplToJson(
        _$WalletAssetTep74Impl instance) =>
    <String, dynamic>{
      'mint': instance.mint,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'balance': const StringOrIntConverter().toJson(instance.balance),
      'kind': instance.kind,
      'name': instance.name,
    };

_$WalletAssetTrc10Impl _$$WalletAssetTrc10ImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletAssetTrc10Impl(
      tokenId: json['tokenId'] as String,
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      balance: const StringOrIntConverter().fromJson(json['balance']),
      kind: json['kind'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$WalletAssetTrc10ImplToJson(
        _$WalletAssetTrc10Impl instance) =>
    <String, dynamic>{
      'tokenId': instance.tokenId,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'balance': const StringOrIntConverter().toJson(instance.balance),
      'kind': instance.kind,
      'name': instance.name,
    };

_$WalletAssetTrc20Impl _$$WalletAssetTrc20ImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletAssetTrc20Impl(
      contract: json['contract'] as String,
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      balance: const StringOrIntConverter().fromJson(json['balance']),
      kind: json['kind'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$WalletAssetTrc20ImplToJson(
        _$WalletAssetTrc20Impl instance) =>
    <String, dynamic>{
      'contract': instance.contract,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'balance': const StringOrIntConverter().toJson(instance.balance),
      'kind': instance.kind,
      'name': instance.name,
    };

_$WalletAssetUnknownImpl _$$WalletAssetUnknownImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletAssetUnknownImpl(
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      balance: const StringOrIntConverter().fromJson(json['balance']),
      kind: json['kind'] as String,
      contract: json['contract'] as String?,
      name: json['name'] as String?,
      assetId: json['assetId'] as String?,
      mint: json['mint'] as String?,
      tokenId: json['tokenId'] as String?,
      verified: json['verified'] as bool?,
    );

Map<String, dynamic> _$$WalletAssetUnknownImplToJson(
        _$WalletAssetUnknownImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'balance': const StringOrIntConverter().toJson(instance.balance),
      'kind': instance.kind,
      'contract': instance.contract,
      'name': instance.name,
      'assetId': instance.assetId,
      'mint': instance.mint,
      'tokenId': instance.tokenId,
      'verified': instance.verified,
    };
