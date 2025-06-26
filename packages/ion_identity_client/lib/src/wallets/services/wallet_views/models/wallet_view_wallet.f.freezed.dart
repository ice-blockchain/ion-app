// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_view_wallet.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletViewWallet _$WalletViewWalletFromJson(Map<String, dynamic> json) {
  return _WalletViewWallet.fromJson(json);
}

/// @nodoc
mixin _$WalletViewWallet {
  Map<String, String> get asset => throw _privateConstructorUsedError;
  String get network => throw _privateConstructorUsedError;
  String get walletId => throw _privateConstructorUsedError;

  /// Serializes this WalletViewWallet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletViewWallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletViewWalletCopyWith<WalletViewWallet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletViewWalletCopyWith<$Res> {
  factory $WalletViewWalletCopyWith(
          WalletViewWallet value, $Res Function(WalletViewWallet) then) =
      _$WalletViewWalletCopyWithImpl<$Res, WalletViewWallet>;
  @useResult
  $Res call({Map<String, String> asset, String network, String walletId});
}

/// @nodoc
class _$WalletViewWalletCopyWithImpl<$Res, $Val extends WalletViewWallet>
    implements $WalletViewWalletCopyWith<$Res> {
  _$WalletViewWalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletViewWallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asset = null,
    Object? network = null,
    Object? walletId = null,
  }) {
    return _then(_value.copyWith(
      asset: null == asset
          ? _value.asset
          : asset // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletViewWalletImplCopyWith<$Res>
    implements $WalletViewWalletCopyWith<$Res> {
  factory _$$WalletViewWalletImplCopyWith(_$WalletViewWalletImpl value,
          $Res Function(_$WalletViewWalletImpl) then) =
      __$$WalletViewWalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, String> asset, String network, String walletId});
}

/// @nodoc
class __$$WalletViewWalletImplCopyWithImpl<$Res>
    extends _$WalletViewWalletCopyWithImpl<$Res, _$WalletViewWalletImpl>
    implements _$$WalletViewWalletImplCopyWith<$Res> {
  __$$WalletViewWalletImplCopyWithImpl(_$WalletViewWalletImpl _value,
      $Res Function(_$WalletViewWalletImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletViewWallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asset = null,
    Object? network = null,
    Object? walletId = null,
  }) {
    return _then(_$WalletViewWalletImpl(
      asset: null == asset
          ? _value._asset
          : asset // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletViewWalletImpl implements _WalletViewWallet {
  const _$WalletViewWalletImpl(
      {required final Map<String, String> asset,
      required this.network,
      required this.walletId})
      : _asset = asset;

  factory _$WalletViewWalletImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletViewWalletImplFromJson(json);

  final Map<String, String> _asset;
  @override
  Map<String, String> get asset {
    if (_asset is EqualUnmodifiableMapView) return _asset;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_asset);
  }

  @override
  final String network;
  @override
  final String walletId;

  @override
  String toString() {
    return 'WalletViewWallet(asset: $asset, network: $network, walletId: $walletId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletViewWalletImpl &&
            const DeepCollectionEquality().equals(other._asset, _asset) &&
            (identical(other.network, network) || other.network == network) &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_asset), network, walletId);

  /// Create a copy of WalletViewWallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletViewWalletImplCopyWith<_$WalletViewWalletImpl> get copyWith =>
      __$$WalletViewWalletImplCopyWithImpl<_$WalletViewWalletImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletViewWalletImplToJson(
      this,
    );
  }
}

abstract class _WalletViewWallet implements WalletViewWallet {
  const factory _WalletViewWallet(
      {required final Map<String, String> asset,
      required final String network,
      required final String walletId}) = _$WalletViewWalletImpl;

  factory _WalletViewWallet.fromJson(Map<String, dynamic> json) =
      _$WalletViewWalletImpl.fromJson;

  @override
  Map<String, String> get asset;
  @override
  String get network;
  @override
  String get walletId;

  /// Create a copy of WalletViewWallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletViewWalletImplCopyWith<_$WalletViewWalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
