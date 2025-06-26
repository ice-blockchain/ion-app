// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_view_coin_data.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletViewCoinData _$WalletViewCoinDataFromJson(Map<String, dynamic> json) {
  return _WalletViewCoinData.fromJson(json);
}

/// @nodoc
mixin _$WalletViewCoinData {
  String get coinId => throw _privateConstructorUsedError;
  String? get walletId => throw _privateConstructorUsedError;

  /// Serializes this WalletViewCoinData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletViewCoinData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletViewCoinDataCopyWith<WalletViewCoinData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletViewCoinDataCopyWith<$Res> {
  factory $WalletViewCoinDataCopyWith(
          WalletViewCoinData value, $Res Function(WalletViewCoinData) then) =
      _$WalletViewCoinDataCopyWithImpl<$Res, WalletViewCoinData>;
  @useResult
  $Res call({String coinId, String? walletId});
}

/// @nodoc
class _$WalletViewCoinDataCopyWithImpl<$Res, $Val extends WalletViewCoinData>
    implements $WalletViewCoinDataCopyWith<$Res> {
  _$WalletViewCoinDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletViewCoinData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coinId = null,
    Object? walletId = freezed,
  }) {
    return _then(_value.copyWith(
      coinId: null == coinId
          ? _value.coinId
          : coinId // ignore: cast_nullable_to_non_nullable
              as String,
      walletId: freezed == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletViewCoinDataImplCopyWith<$Res>
    implements $WalletViewCoinDataCopyWith<$Res> {
  factory _$$WalletViewCoinDataImplCopyWith(_$WalletViewCoinDataImpl value,
          $Res Function(_$WalletViewCoinDataImpl) then) =
      __$$WalletViewCoinDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String coinId, String? walletId});
}

/// @nodoc
class __$$WalletViewCoinDataImplCopyWithImpl<$Res>
    extends _$WalletViewCoinDataCopyWithImpl<$Res, _$WalletViewCoinDataImpl>
    implements _$$WalletViewCoinDataImplCopyWith<$Res> {
  __$$WalletViewCoinDataImplCopyWithImpl(_$WalletViewCoinDataImpl _value,
      $Res Function(_$WalletViewCoinDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletViewCoinData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coinId = null,
    Object? walletId = freezed,
  }) {
    return _then(_$WalletViewCoinDataImpl(
      coinId: null == coinId
          ? _value.coinId
          : coinId // ignore: cast_nullable_to_non_nullable
              as String,
      walletId: freezed == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletViewCoinDataImpl implements _WalletViewCoinData {
  const _$WalletViewCoinDataImpl({required this.coinId, this.walletId});

  factory _$WalletViewCoinDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletViewCoinDataImplFromJson(json);

  @override
  final String coinId;
  @override
  final String? walletId;

  @override
  String toString() {
    return 'WalletViewCoinData(coinId: $coinId, walletId: $walletId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletViewCoinDataImpl &&
            (identical(other.coinId, coinId) || other.coinId == coinId) &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, coinId, walletId);

  /// Create a copy of WalletViewCoinData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletViewCoinDataImplCopyWith<_$WalletViewCoinDataImpl> get copyWith =>
      __$$WalletViewCoinDataImplCopyWithImpl<_$WalletViewCoinDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletViewCoinDataImplToJson(
      this,
    );
  }
}

abstract class _WalletViewCoinData implements WalletViewCoinData {
  const factory _WalletViewCoinData(
      {required final String coinId,
      final String? walletId}) = _$WalletViewCoinDataImpl;

  factory _WalletViewCoinData.fromJson(Map<String, dynamic> json) =
      _$WalletViewCoinDataImpl.fromJson;

  @override
  String get coinId;
  @override
  String? get walletId;

  /// Create a copy of WalletViewCoinData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletViewCoinDataImplCopyWith<_$WalletViewCoinDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
