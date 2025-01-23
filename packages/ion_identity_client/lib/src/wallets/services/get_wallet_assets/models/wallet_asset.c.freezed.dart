// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_asset.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletAsset _$WalletAssetFromJson(Map<String, dynamic> json) {
  return _WalletAsset.fromJson(json);
}

/// @nodoc
mixin _$WalletAsset {
  String? get name => throw _privateConstructorUsedError;
  String? get contract => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  int get decimals => throw _privateConstructorUsedError;
  String get balance => throw _privateConstructorUsedError;
  bool? get verified => throw _privateConstructorUsedError;

  /// Serializes this WalletAsset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletAsset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletAssetCopyWith<WalletAsset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletAssetCopyWith<$Res> {
  factory $WalletAssetCopyWith(
          WalletAsset value, $Res Function(WalletAsset) then) =
      _$WalletAssetCopyWithImpl<$Res, WalletAsset>;
  @useResult
  $Res call(
      {String? name,
      String? contract,
      String symbol,
      int decimals,
      String balance,
      bool? verified});
}

/// @nodoc
class _$WalletAssetCopyWithImpl<$Res, $Val extends WalletAsset>
    implements $WalletAssetCopyWith<$Res> {
  _$WalletAssetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletAsset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? contract = freezed,
    Object? symbol = null,
    Object? decimals = null,
    Object? balance = null,
    Object? verified = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      contract: freezed == contract
          ? _value.contract
          : contract // ignore: cast_nullable_to_non_nullable
              as String?,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      decimals: null == decimals
          ? _value.decimals
          : decimals // ignore: cast_nullable_to_non_nullable
              as int,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String,
      verified: freezed == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletAssetImplCopyWith<$Res>
    implements $WalletAssetCopyWith<$Res> {
  factory _$$WalletAssetImplCopyWith(
          _$WalletAssetImpl value, $Res Function(_$WalletAssetImpl) then) =
      __$$WalletAssetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      String? contract,
      String symbol,
      int decimals,
      String balance,
      bool? verified});
}

/// @nodoc
class __$$WalletAssetImplCopyWithImpl<$Res>
    extends _$WalletAssetCopyWithImpl<$Res, _$WalletAssetImpl>
    implements _$$WalletAssetImplCopyWith<$Res> {
  __$$WalletAssetImplCopyWithImpl(
      _$WalletAssetImpl _value, $Res Function(_$WalletAssetImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletAsset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? contract = freezed,
    Object? symbol = null,
    Object? decimals = null,
    Object? balance = null,
    Object? verified = freezed,
  }) {
    return _then(_$WalletAssetImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      contract: freezed == contract
          ? _value.contract
          : contract // ignore: cast_nullable_to_non_nullable
              as String?,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      decimals: null == decimals
          ? _value.decimals
          : decimals // ignore: cast_nullable_to_non_nullable
              as int,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String,
      verified: freezed == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletAssetImpl implements _WalletAsset {
  const _$WalletAssetImpl(
      {required this.name,
      required this.contract,
      required this.symbol,
      required this.decimals,
      required this.balance,
      required this.verified});

  factory _$WalletAssetImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletAssetImplFromJson(json);

  @override
  final String? name;
  @override
  final String? contract;
  @override
  final String symbol;
  @override
  final int decimals;
  @override
  final String balance;
  @override
  final bool? verified;

  @override
  String toString() {
    return 'WalletAsset(name: $name, contract: $contract, symbol: $symbol, decimals: $decimals, balance: $balance, verified: $verified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletAssetImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.contract, contract) ||
                other.contract == contract) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.decimals, decimals) ||
                other.decimals == decimals) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.verified, verified) ||
                other.verified == verified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, contract, symbol, decimals, balance, verified);

  /// Create a copy of WalletAsset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletAssetImplCopyWith<_$WalletAssetImpl> get copyWith =>
      __$$WalletAssetImplCopyWithImpl<_$WalletAssetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletAssetImplToJson(
      this,
    );
  }
}

abstract class _WalletAsset implements WalletAsset {
  const factory _WalletAsset(
      {required final String? name,
      required final String? contract,
      required final String symbol,
      required final int decimals,
      required final String balance,
      required final bool? verified}) = _$WalletAssetImpl;

  factory _WalletAsset.fromJson(Map<String, dynamic> json) =
      _$WalletAssetImpl.fromJson;

  @override
  String? get name;
  @override
  String? get contract;
  @override
  String get symbol;
  @override
  int get decimals;
  @override
  String get balance;
  @override
  bool? get verified;

  /// Create a copy of WalletAsset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletAssetImplCopyWith<_$WalletAssetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
