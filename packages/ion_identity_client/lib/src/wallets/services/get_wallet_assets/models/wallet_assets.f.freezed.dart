// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_assets.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletAssets _$WalletAssetsFromJson(Map<String, dynamic> json) {
  return _WalletAssets.fromJson(json);
}

/// @nodoc
mixin _$WalletAssets {
  String get walletId => throw _privateConstructorUsedError;
  String get network => throw _privateConstructorUsedError;
  List<WalletAsset> get assets => throw _privateConstructorUsedError;

  /// Serializes this WalletAssets to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletAssets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletAssetsCopyWith<WalletAssets> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletAssetsCopyWith<$Res> {
  factory $WalletAssetsCopyWith(
          WalletAssets value, $Res Function(WalletAssets) then) =
      _$WalletAssetsCopyWithImpl<$Res, WalletAssets>;
  @useResult
  $Res call({String walletId, String network, List<WalletAsset> assets});
}

/// @nodoc
class _$WalletAssetsCopyWithImpl<$Res, $Val extends WalletAssets>
    implements $WalletAssetsCopyWith<$Res> {
  _$WalletAssetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletAssets
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
              as List<WalletAsset>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletAssetsImplCopyWith<$Res>
    implements $WalletAssetsCopyWith<$Res> {
  factory _$$WalletAssetsImplCopyWith(
          _$WalletAssetsImpl value, $Res Function(_$WalletAssetsImpl) then) =
      __$$WalletAssetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String walletId, String network, List<WalletAsset> assets});
}

/// @nodoc
class __$$WalletAssetsImplCopyWithImpl<$Res>
    extends _$WalletAssetsCopyWithImpl<$Res, _$WalletAssetsImpl>
    implements _$$WalletAssetsImplCopyWith<$Res> {
  __$$WalletAssetsImplCopyWithImpl(
      _$WalletAssetsImpl _value, $Res Function(_$WalletAssetsImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletAssets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletId = null,
    Object? network = null,
    Object? assets = null,
  }) {
    return _then(_$WalletAssetsImpl(
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
              as List<WalletAsset>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletAssetsImpl implements _WalletAssets {
  _$WalletAssetsImpl(
      {required this.walletId,
      required this.network,
      required final List<WalletAsset> assets})
      : _assets = assets;

  factory _$WalletAssetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletAssetsImplFromJson(json);

  @override
  final String walletId;
  @override
  final String network;
  final List<WalletAsset> _assets;
  @override
  List<WalletAsset> get assets {
    if (_assets is EqualUnmodifiableListView) return _assets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assets);
  }

  @override
  String toString() {
    return 'WalletAssets(walletId: $walletId, network: $network, assets: $assets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletAssetsImpl &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId) &&
            (identical(other.network, network) || other.network == network) &&
            const DeepCollectionEquality().equals(other._assets, _assets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, walletId, network,
      const DeepCollectionEquality().hash(_assets));

  /// Create a copy of WalletAssets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletAssetsImplCopyWith<_$WalletAssetsImpl> get copyWith =>
      __$$WalletAssetsImplCopyWithImpl<_$WalletAssetsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletAssetsImplToJson(
      this,
    );
  }
}

abstract class _WalletAssets implements WalletAssets {
  factory _WalletAssets(
      {required final String walletId,
      required final String network,
      required final List<WalletAsset> assets}) = _$WalletAssetsImpl;

  factory _WalletAssets.fromJson(Map<String, dynamic> json) =
      _$WalletAssetsImpl.fromJson;

  @override
  String get walletId;
  @override
  String get network;
  @override
  List<WalletAsset> get assets;

  /// Create a copy of WalletAssets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletAssetsImplCopyWith<_$WalletAssetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
