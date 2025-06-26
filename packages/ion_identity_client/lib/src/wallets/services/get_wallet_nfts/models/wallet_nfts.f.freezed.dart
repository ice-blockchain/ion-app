// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_nfts.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletNfts _$WalletNftsFromJson(Map<String, dynamic> json) {
  return _WalletNfts.fromJson(json);
}

/// @nodoc
mixin _$WalletNfts {
  String get walletId => throw _privateConstructorUsedError;
  String get network => throw _privateConstructorUsedError;
  List<WalletNft> get nfts => throw _privateConstructorUsedError;

  /// Serializes this WalletNfts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletNfts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletNftsCopyWith<WalletNfts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletNftsCopyWith<$Res> {
  factory $WalletNftsCopyWith(
          WalletNfts value, $Res Function(WalletNfts) then) =
      _$WalletNftsCopyWithImpl<$Res, WalletNfts>;
  @useResult
  $Res call({String walletId, String network, List<WalletNft> nfts});
}

/// @nodoc
class _$WalletNftsCopyWithImpl<$Res, $Val extends WalletNfts>
    implements $WalletNftsCopyWith<$Res> {
  _$WalletNftsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletNfts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletId = null,
    Object? network = null,
    Object? nfts = null,
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
      nfts: null == nfts
          ? _value.nfts
          : nfts // ignore: cast_nullable_to_non_nullable
              as List<WalletNft>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletNftsImplCopyWith<$Res>
    implements $WalletNftsCopyWith<$Res> {
  factory _$$WalletNftsImplCopyWith(
          _$WalletNftsImpl value, $Res Function(_$WalletNftsImpl) then) =
      __$$WalletNftsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String walletId, String network, List<WalletNft> nfts});
}

/// @nodoc
class __$$WalletNftsImplCopyWithImpl<$Res>
    extends _$WalletNftsCopyWithImpl<$Res, _$WalletNftsImpl>
    implements _$$WalletNftsImplCopyWith<$Res> {
  __$$WalletNftsImplCopyWithImpl(
      _$WalletNftsImpl _value, $Res Function(_$WalletNftsImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletNfts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletId = null,
    Object? network = null,
    Object? nfts = null,
  }) {
    return _then(_$WalletNftsImpl(
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      nfts: null == nfts
          ? _value._nfts
          : nfts // ignore: cast_nullable_to_non_nullable
              as List<WalletNft>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletNftsImpl implements _WalletNfts {
  const _$WalletNftsImpl(
      {required this.walletId,
      required this.network,
      required final List<WalletNft> nfts})
      : _nfts = nfts;

  factory _$WalletNftsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletNftsImplFromJson(json);

  @override
  final String walletId;
  @override
  final String network;
  final List<WalletNft> _nfts;
  @override
  List<WalletNft> get nfts {
    if (_nfts is EqualUnmodifiableListView) return _nfts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nfts);
  }

  @override
  String toString() {
    return 'WalletNfts(walletId: $walletId, network: $network, nfts: $nfts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletNftsImpl &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId) &&
            (identical(other.network, network) || other.network == network) &&
            const DeepCollectionEquality().equals(other._nfts, _nfts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, walletId, network,
      const DeepCollectionEquality().hash(_nfts));

  /// Create a copy of WalletNfts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletNftsImplCopyWith<_$WalletNftsImpl> get copyWith =>
      __$$WalletNftsImplCopyWithImpl<_$WalletNftsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletNftsImplToJson(
      this,
    );
  }
}

abstract class _WalletNfts implements WalletNfts {
  const factory _WalletNfts(
      {required final String walletId,
      required final String network,
      required final List<WalletNft> nfts}) = _$WalletNftsImpl;

  factory _WalletNfts.fromJson(Map<String, dynamic> json) =
      _$WalletNftsImpl.fromJson;

  @override
  String get walletId;
  @override
  String get network;
  @override
  List<WalletNft> get nfts;

  /// Create a copy of WalletNfts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletNftsImplCopyWith<_$WalletNftsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
