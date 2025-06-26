// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_view_aggregation_wallet.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletViewAggregationWallet _$WalletViewAggregationWalletFromJson(
    Map<String, dynamic> json) {
  return _WalletViewAggregationWallet.fromJson(json);
}

/// @nodoc
mixin _$WalletViewAggregationWallet {
  WalletAsset get asset => throw _privateConstructorUsedError;
  String get walletId => throw _privateConstructorUsedError;
  String get network => throw _privateConstructorUsedError;
  String? get coinId => throw _privateConstructorUsedError;

  /// Serializes this WalletViewAggregationWallet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletViewAggregationWallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletViewAggregationWalletCopyWith<WalletViewAggregationWallet>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletViewAggregationWalletCopyWith<$Res> {
  factory $WalletViewAggregationWalletCopyWith(
          WalletViewAggregationWallet value,
          $Res Function(WalletViewAggregationWallet) then) =
      _$WalletViewAggregationWalletCopyWithImpl<$Res,
          WalletViewAggregationWallet>;
  @useResult
  $Res call(
      {WalletAsset asset, String walletId, String network, String? coinId});

  $WalletAssetCopyWith<$Res> get asset;
}

/// @nodoc
class _$WalletViewAggregationWalletCopyWithImpl<$Res,
        $Val extends WalletViewAggregationWallet>
    implements $WalletViewAggregationWalletCopyWith<$Res> {
  _$WalletViewAggregationWalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletViewAggregationWallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asset = null,
    Object? walletId = null,
    Object? network = null,
    Object? coinId = freezed,
  }) {
    return _then(_value.copyWith(
      asset: null == asset
          ? _value.asset
          : asset // ignore: cast_nullable_to_non_nullable
              as WalletAsset,
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      coinId: freezed == coinId
          ? _value.coinId
          : coinId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of WalletViewAggregationWallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalletAssetCopyWith<$Res> get asset {
    return $WalletAssetCopyWith<$Res>(_value.asset, (value) {
      return _then(_value.copyWith(asset: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WalletViewAggregationWalletImplCopyWith<$Res>
    implements $WalletViewAggregationWalletCopyWith<$Res> {
  factory _$$WalletViewAggregationWalletImplCopyWith(
          _$WalletViewAggregationWalletImpl value,
          $Res Function(_$WalletViewAggregationWalletImpl) then) =
      __$$WalletViewAggregationWalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {WalletAsset asset, String walletId, String network, String? coinId});

  @override
  $WalletAssetCopyWith<$Res> get asset;
}

/// @nodoc
class __$$WalletViewAggregationWalletImplCopyWithImpl<$Res>
    extends _$WalletViewAggregationWalletCopyWithImpl<$Res,
        _$WalletViewAggregationWalletImpl>
    implements _$$WalletViewAggregationWalletImplCopyWith<$Res> {
  __$$WalletViewAggregationWalletImplCopyWithImpl(
      _$WalletViewAggregationWalletImpl _value,
      $Res Function(_$WalletViewAggregationWalletImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletViewAggregationWallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asset = null,
    Object? walletId = null,
    Object? network = null,
    Object? coinId = freezed,
  }) {
    return _then(_$WalletViewAggregationWalletImpl(
      asset: null == asset
          ? _value.asset
          : asset // ignore: cast_nullable_to_non_nullable
              as WalletAsset,
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      coinId: freezed == coinId
          ? _value.coinId
          : coinId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletViewAggregationWalletImpl
    implements _WalletViewAggregationWallet {
  const _$WalletViewAggregationWalletImpl(
      {required this.asset,
      required this.walletId,
      required this.network,
      this.coinId});

  factory _$WalletViewAggregationWalletImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$WalletViewAggregationWalletImplFromJson(json);

  @override
  final WalletAsset asset;
  @override
  final String walletId;
  @override
  final String network;
  @override
  final String? coinId;

  @override
  String toString() {
    return 'WalletViewAggregationWallet(asset: $asset, walletId: $walletId, network: $network, coinId: $coinId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletViewAggregationWalletImpl &&
            (identical(other.asset, asset) || other.asset == asset) &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId) &&
            (identical(other.network, network) || other.network == network) &&
            (identical(other.coinId, coinId) || other.coinId == coinId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, asset, walletId, network, coinId);

  /// Create a copy of WalletViewAggregationWallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletViewAggregationWalletImplCopyWith<_$WalletViewAggregationWalletImpl>
      get copyWith => __$$WalletViewAggregationWalletImplCopyWithImpl<
          _$WalletViewAggregationWalletImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletViewAggregationWalletImplToJson(
      this,
    );
  }
}

abstract class _WalletViewAggregationWallet
    implements WalletViewAggregationWallet {
  const factory _WalletViewAggregationWallet(
      {required final WalletAsset asset,
      required final String walletId,
      required final String network,
      final String? coinId}) = _$WalletViewAggregationWalletImpl;

  factory _WalletViewAggregationWallet.fromJson(Map<String, dynamic> json) =
      _$WalletViewAggregationWalletImpl.fromJson;

  @override
  WalletAsset get asset;
  @override
  String get walletId;
  @override
  String get network;
  @override
  String? get coinId;

  /// Create a copy of WalletViewAggregationWallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletViewAggregationWalletImplCopyWith<_$WalletViewAggregationWalletImpl>
      get copyWith => throw _privateConstructorUsedError;
}
