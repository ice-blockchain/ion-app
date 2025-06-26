// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin_in_wallet.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CoinInWallet _$CoinInWalletFromJson(Map<String, dynamic> json) {
  return _CoinInWallet.fromJson(json);
}

/// @nodoc
mixin _$CoinInWallet {
  Coin get coin => throw _privateConstructorUsedError;
  String? get walletId => throw _privateConstructorUsedError;

  /// Serializes this CoinInWallet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoinInWallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoinInWalletCopyWith<CoinInWallet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoinInWalletCopyWith<$Res> {
  factory $CoinInWalletCopyWith(
          CoinInWallet value, $Res Function(CoinInWallet) then) =
      _$CoinInWalletCopyWithImpl<$Res, CoinInWallet>;
  @useResult
  $Res call({Coin coin, String? walletId});

  $CoinCopyWith<$Res> get coin;
}

/// @nodoc
class _$CoinInWalletCopyWithImpl<$Res, $Val extends CoinInWallet>
    implements $CoinInWalletCopyWith<$Res> {
  _$CoinInWalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoinInWallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coin = null,
    Object? walletId = freezed,
  }) {
    return _then(_value.copyWith(
      coin: null == coin
          ? _value.coin
          : coin // ignore: cast_nullable_to_non_nullable
              as Coin,
      walletId: freezed == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of CoinInWallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoinCopyWith<$Res> get coin {
    return $CoinCopyWith<$Res>(_value.coin, (value) {
      return _then(_value.copyWith(coin: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CoinInWalletImplCopyWith<$Res>
    implements $CoinInWalletCopyWith<$Res> {
  factory _$$CoinInWalletImplCopyWith(
          _$CoinInWalletImpl value, $Res Function(_$CoinInWalletImpl) then) =
      __$$CoinInWalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Coin coin, String? walletId});

  @override
  $CoinCopyWith<$Res> get coin;
}

/// @nodoc
class __$$CoinInWalletImplCopyWithImpl<$Res>
    extends _$CoinInWalletCopyWithImpl<$Res, _$CoinInWalletImpl>
    implements _$$CoinInWalletImplCopyWith<$Res> {
  __$$CoinInWalletImplCopyWithImpl(
      _$CoinInWalletImpl _value, $Res Function(_$CoinInWalletImpl) _then)
      : super(_value, _then);

  /// Create a copy of CoinInWallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coin = null,
    Object? walletId = freezed,
  }) {
    return _then(_$CoinInWalletImpl(
      coin: null == coin
          ? _value.coin
          : coin // ignore: cast_nullable_to_non_nullable
              as Coin,
      walletId: freezed == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoinInWalletImpl implements _CoinInWallet {
  _$CoinInWalletImpl({required this.coin, this.walletId});

  factory _$CoinInWalletImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoinInWalletImplFromJson(json);

  @override
  final Coin coin;
  @override
  final String? walletId;

  @override
  String toString() {
    return 'CoinInWallet(coin: $coin, walletId: $walletId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoinInWalletImpl &&
            (identical(other.coin, coin) || other.coin == coin) &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, coin, walletId);

  /// Create a copy of CoinInWallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoinInWalletImplCopyWith<_$CoinInWalletImpl> get copyWith =>
      __$$CoinInWalletImplCopyWithImpl<_$CoinInWalletImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoinInWalletImplToJson(
      this,
    );
  }
}

abstract class _CoinInWallet implements CoinInWallet {
  factory _CoinInWallet({required final Coin coin, final String? walletId}) =
      _$CoinInWalletImpl;

  factory _CoinInWallet.fromJson(Map<String, dynamic> json) =
      _$CoinInWalletImpl.fromJson;

  @override
  Coin get coin;
  @override
  String? get walletId;

  /// Create a copy of CoinInWallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoinInWalletImplCopyWith<_$CoinInWalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
