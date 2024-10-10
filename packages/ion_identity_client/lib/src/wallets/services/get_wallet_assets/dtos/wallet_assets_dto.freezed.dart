// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_assets_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletAssetsDto _$WalletAssetsDtoFromJson(Map<String, dynamic> json) {
  return _WalletAssetsDto.fromJson(json);
}

/// @nodoc
mixin _$WalletAssetsDto {
  String get walletId => throw _privateConstructorUsedError;
  String get network => throw _privateConstructorUsedError;
  List<WalletAssetDto> get assets => throw _privateConstructorUsedError;

  /// Serializes this WalletAssetsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletAssetsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletAssetsDtoCopyWith<WalletAssetsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletAssetsDtoCopyWith<$Res> {
  factory $WalletAssetsDtoCopyWith(
          WalletAssetsDto value, $Res Function(WalletAssetsDto) then) =
      _$WalletAssetsDtoCopyWithImpl<$Res, WalletAssetsDto>;
  @useResult
  $Res call({String walletId, String network, List<WalletAssetDto> assets});
}

/// @nodoc
class _$WalletAssetsDtoCopyWithImpl<$Res, $Val extends WalletAssetsDto>
    implements $WalletAssetsDtoCopyWith<$Res> {
  _$WalletAssetsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletAssetsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletId = null,
    Object? network = null,
    Object? assets = null,
  }) {
    return _then(_value.copyWith(
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      assets: null == assets
          ? _value.assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<WalletAssetDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletAssetsDtoImplCopyWith<$Res>
    implements $WalletAssetsDtoCopyWith<$Res> {
  factory _$$WalletAssetsDtoImplCopyWith(_$WalletAssetsDtoImpl value,
          $Res Function(_$WalletAssetsDtoImpl) then) =
      __$$WalletAssetsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String walletId, String network, List<WalletAssetDto> assets});
}

/// @nodoc
class __$$WalletAssetsDtoImplCopyWithImpl<$Res>
    extends _$WalletAssetsDtoCopyWithImpl<$Res, _$WalletAssetsDtoImpl>
    implements _$$WalletAssetsDtoImplCopyWith<$Res> {
  __$$WalletAssetsDtoImplCopyWithImpl(
      _$WalletAssetsDtoImpl _value, $Res Function(_$WalletAssetsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletAssetsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletId = null,
    Object? network = null,
    Object? assets = null,
  }) {
    return _then(_$WalletAssetsDtoImpl(
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      assets: null == assets
          ? _value._assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<WalletAssetDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletAssetsDtoImpl implements _WalletAssetsDto {
  _$WalletAssetsDtoImpl(
      {required this.walletId,
      required this.network,
      required final List<WalletAssetDto> assets})
      : _assets = assets;

  factory _$WalletAssetsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletAssetsDtoImplFromJson(json);

  @override
  final String walletId;
  @override
  final String network;
  final List<WalletAssetDto> _assets;
  @override
  List<WalletAssetDto> get assets {
    if (_assets is EqualUnmodifiableListView) return _assets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assets);
  }

  @override
  String toString() {
    return 'WalletAssetsDto(walletId: $walletId, network: $network, assets: $assets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletAssetsDtoImpl &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId) &&
            (identical(other.network, network) || other.network == network) &&
            const DeepCollectionEquality().equals(other._assets, _assets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, walletId, network,
      const DeepCollectionEquality().hash(_assets));

  /// Create a copy of WalletAssetsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletAssetsDtoImplCopyWith<_$WalletAssetsDtoImpl> get copyWith =>
      __$$WalletAssetsDtoImplCopyWithImpl<_$WalletAssetsDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletAssetsDtoImplToJson(
      this,
    );
  }
}

abstract class _WalletAssetsDto implements WalletAssetsDto {
  factory _WalletAssetsDto(
      {required final String walletId,
      required final String network,
      required final List<WalletAssetDto> assets}) = _$WalletAssetsDtoImpl;

  factory _WalletAssetsDto.fromJson(Map<String, dynamic> json) =
      _$WalletAssetsDtoImpl.fromJson;

  @override
  String get walletId;
  @override
  String get network;
  @override
  List<WalletAssetDto> get assets;

  /// Create a copy of WalletAssetsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletAssetsDtoImplCopyWith<_$WalletAssetsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
