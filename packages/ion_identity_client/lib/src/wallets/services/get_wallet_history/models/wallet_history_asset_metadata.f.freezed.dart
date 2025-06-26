// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_history_asset_metadata.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletHistoryAssetMetadata _$WalletHistoryAssetMetadataFromJson(
    Map<String, dynamic> json) {
  return _WalletHistoryAssetMetadata.fromJson(json);
}

/// @nodoc
mixin _$WalletHistoryAssetMetadata {
  String get symbol => throw _privateConstructorUsedError;
  int? get decimals => throw _privateConstructorUsedError;
  bool? get verified => throw _privateConstructorUsedError;

  /// Serializes this WalletHistoryAssetMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletHistoryAssetMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletHistoryAssetMetadataCopyWith<WalletHistoryAssetMetadata>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletHistoryAssetMetadataCopyWith<$Res> {
  factory $WalletHistoryAssetMetadataCopyWith(WalletHistoryAssetMetadata value,
          $Res Function(WalletHistoryAssetMetadata) then) =
      _$WalletHistoryAssetMetadataCopyWithImpl<$Res,
          WalletHistoryAssetMetadata>;
  @useResult
  $Res call({String symbol, int? decimals, bool? verified});
}

/// @nodoc
class _$WalletHistoryAssetMetadataCopyWithImpl<$Res,
        $Val extends WalletHistoryAssetMetadata>
    implements $WalletHistoryAssetMetadataCopyWith<$Res> {
  _$WalletHistoryAssetMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletHistoryAssetMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? decimals = freezed,
    Object? verified = freezed,
  }) {
    return _then(_value.copyWith(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      decimals: freezed == decimals
          ? _value.decimals
          : decimals // ignore: cast_nullable_to_non_nullable
              as int?,
      verified: freezed == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletHistoryAssetMetadataImplCopyWith<$Res>
    implements $WalletHistoryAssetMetadataCopyWith<$Res> {
  factory _$$WalletHistoryAssetMetadataImplCopyWith(
          _$WalletHistoryAssetMetadataImpl value,
          $Res Function(_$WalletHistoryAssetMetadataImpl) then) =
      __$$WalletHistoryAssetMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String symbol, int? decimals, bool? verified});
}

/// @nodoc
class __$$WalletHistoryAssetMetadataImplCopyWithImpl<$Res>
    extends _$WalletHistoryAssetMetadataCopyWithImpl<$Res,
        _$WalletHistoryAssetMetadataImpl>
    implements _$$WalletHistoryAssetMetadataImplCopyWith<$Res> {
  __$$WalletHistoryAssetMetadataImplCopyWithImpl(
      _$WalletHistoryAssetMetadataImpl _value,
      $Res Function(_$WalletHistoryAssetMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletHistoryAssetMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? decimals = freezed,
    Object? verified = freezed,
  }) {
    return _then(_$WalletHistoryAssetMetadataImpl(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      decimals: freezed == decimals
          ? _value.decimals
          : decimals // ignore: cast_nullable_to_non_nullable
              as int?,
      verified: freezed == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletHistoryAssetMetadataImpl implements _WalletHistoryAssetMetadata {
  const _$WalletHistoryAssetMetadataImpl(
      {required this.symbol, required this.decimals, required this.verified});

  factory _$WalletHistoryAssetMetadataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$WalletHistoryAssetMetadataImplFromJson(json);

  @override
  final String symbol;
  @override
  final int? decimals;
  @override
  final bool? verified;

  @override
  String toString() {
    return 'WalletHistoryAssetMetadata(symbol: $symbol, decimals: $decimals, verified: $verified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletHistoryAssetMetadataImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.decimals, decimals) ||
                other.decimals == decimals) &&
            (identical(other.verified, verified) ||
                other.verified == verified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, decimals, verified);

  /// Create a copy of WalletHistoryAssetMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletHistoryAssetMetadataImplCopyWith<_$WalletHistoryAssetMetadataImpl>
      get copyWith => __$$WalletHistoryAssetMetadataImplCopyWithImpl<
          _$WalletHistoryAssetMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletHistoryAssetMetadataImplToJson(
      this,
    );
  }
}

abstract class _WalletHistoryAssetMetadata
    implements WalletHistoryAssetMetadata {
  const factory _WalletHistoryAssetMetadata(
      {required final String symbol,
      required final int? decimals,
      required final bool? verified}) = _$WalletHistoryAssetMetadataImpl;

  factory _WalletHistoryAssetMetadata.fromJson(Map<String, dynamic> json) =
      _$WalletHistoryAssetMetadataImpl.fromJson;

  @override
  String get symbol;
  @override
  int? get decimals;
  @override
  bool? get verified;

  /// Create a copy of WalletHistoryAssetMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletHistoryAssetMetadataImplCopyWith<_$WalletHistoryAssetMetadataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
