// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_history_metadata.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletHistoryMetadata _$WalletHistoryMetadataFromJson(
    Map<String, dynamic> json) {
  return _WalletHistoryMetadata.fromJson(json);
}

/// @nodoc
mixin _$WalletHistoryMetadata {
  WalletHistoryAssetMetadata get asset => throw _privateConstructorUsedError;
  WalletHistoryAssetMetadata get fee => throw _privateConstructorUsedError;

  /// Serializes this WalletHistoryMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletHistoryMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletHistoryMetadataCopyWith<WalletHistoryMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletHistoryMetadataCopyWith<$Res> {
  factory $WalletHistoryMetadataCopyWith(WalletHistoryMetadata value,
          $Res Function(WalletHistoryMetadata) then) =
      _$WalletHistoryMetadataCopyWithImpl<$Res, WalletHistoryMetadata>;
  @useResult
  $Res call({WalletHistoryAssetMetadata asset, WalletHistoryAssetMetadata fee});

  $WalletHistoryAssetMetadataCopyWith<$Res> get asset;
  $WalletHistoryAssetMetadataCopyWith<$Res> get fee;
}

/// @nodoc
class _$WalletHistoryMetadataCopyWithImpl<$Res,
        $Val extends WalletHistoryMetadata>
    implements $WalletHistoryMetadataCopyWith<$Res> {
  _$WalletHistoryMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletHistoryMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asset = null,
    Object? fee = null,
  }) {
    return _then(_value.copyWith(
      asset: null == asset
          ? _value.asset
          : asset // ignore: cast_nullable_to_non_nullable
              as WalletHistoryAssetMetadata,
      fee: null == fee
          ? _value.fee
          : fee // ignore: cast_nullable_to_non_nullable
              as WalletHistoryAssetMetadata,
    ) as $Val);
  }

  /// Create a copy of WalletHistoryMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalletHistoryAssetMetadataCopyWith<$Res> get asset {
    return $WalletHistoryAssetMetadataCopyWith<$Res>(_value.asset, (value) {
      return _then(_value.copyWith(asset: value) as $Val);
    });
  }

  /// Create a copy of WalletHistoryMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalletHistoryAssetMetadataCopyWith<$Res> get fee {
    return $WalletHistoryAssetMetadataCopyWith<$Res>(_value.fee, (value) {
      return _then(_value.copyWith(fee: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WalletHistoryMetadataImplCopyWith<$Res>
    implements $WalletHistoryMetadataCopyWith<$Res> {
  factory _$$WalletHistoryMetadataImplCopyWith(
          _$WalletHistoryMetadataImpl value,
          $Res Function(_$WalletHistoryMetadataImpl) then) =
      __$$WalletHistoryMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WalletHistoryAssetMetadata asset, WalletHistoryAssetMetadata fee});

  @override
  $WalletHistoryAssetMetadataCopyWith<$Res> get asset;
  @override
  $WalletHistoryAssetMetadataCopyWith<$Res> get fee;
}

/// @nodoc
class __$$WalletHistoryMetadataImplCopyWithImpl<$Res>
    extends _$WalletHistoryMetadataCopyWithImpl<$Res,
        _$WalletHistoryMetadataImpl>
    implements _$$WalletHistoryMetadataImplCopyWith<$Res> {
  __$$WalletHistoryMetadataImplCopyWithImpl(_$WalletHistoryMetadataImpl _value,
      $Res Function(_$WalletHistoryMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletHistoryMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asset = null,
    Object? fee = null,
  }) {
    return _then(_$WalletHistoryMetadataImpl(
      asset: null == asset
          ? _value.asset
          : asset // ignore: cast_nullable_to_non_nullable
              as WalletHistoryAssetMetadata,
      fee: null == fee
          ? _value.fee
          : fee // ignore: cast_nullable_to_non_nullable
              as WalletHistoryAssetMetadata,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletHistoryMetadataImpl implements _WalletHistoryMetadata {
  const _$WalletHistoryMetadataImpl({required this.asset, required this.fee});

  factory _$WalletHistoryMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletHistoryMetadataImplFromJson(json);

  @override
  final WalletHistoryAssetMetadata asset;
  @override
  final WalletHistoryAssetMetadata fee;

  @override
  String toString() {
    return 'WalletHistoryMetadata(asset: $asset, fee: $fee)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletHistoryMetadataImpl &&
            (identical(other.asset, asset) || other.asset == asset) &&
            (identical(other.fee, fee) || other.fee == fee));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, asset, fee);

  /// Create a copy of WalletHistoryMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletHistoryMetadataImplCopyWith<_$WalletHistoryMetadataImpl>
      get copyWith => __$$WalletHistoryMetadataImplCopyWithImpl<
          _$WalletHistoryMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletHistoryMetadataImplToJson(
      this,
    );
  }
}

abstract class _WalletHistoryMetadata implements WalletHistoryMetadata {
  const factory _WalletHistoryMetadata(
          {required final WalletHistoryAssetMetadata asset,
          required final WalletHistoryAssetMetadata fee}) =
      _$WalletHistoryMetadataImpl;

  factory _WalletHistoryMetadata.fromJson(Map<String, dynamic> json) =
      _$WalletHistoryMetadataImpl.fromJson;

  @override
  WalletHistoryAssetMetadata get asset;
  @override
  WalletHistoryAssetMetadata get fee;

  /// Create a copy of WalletHistoryMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletHistoryMetadataImplCopyWith<_$WalletHistoryMetadataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
