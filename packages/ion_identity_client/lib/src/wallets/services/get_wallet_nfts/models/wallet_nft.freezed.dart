// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_nft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletNft _$WalletNftFromJson(Map<String, dynamic> json) {
  return _WalletNft.fromJson(json);
}

/// @nodoc
mixin _$WalletNft {
  String get kind => throw _privateConstructorUsedError;
  String get contract => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get tokenUri => throw _privateConstructorUsedError;

  /// Serializes this WalletNft to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletNft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletNftCopyWith<WalletNft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletNftCopyWith<$Res> {
  factory $WalletNftCopyWith(WalletNft value, $Res Function(WalletNft) then) =
      _$WalletNftCopyWithImpl<$Res, WalletNft>;
  @useResult
  $Res call(
      {String kind,
      String contract,
      String symbol,
      String tokenId,
      String tokenUri});
}

/// @nodoc
class _$WalletNftCopyWithImpl<$Res, $Val extends WalletNft>
    implements $WalletNftCopyWith<$Res> {
  _$WalletNftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletNft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? contract = null,
    Object? symbol = null,
    Object? tokenId = null,
    Object? tokenUri = null,
  }) {
    return _then(_value.copyWith(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      contract: null == contract
          ? _value.contract
          : contract // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: null == tokenId
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenUri: null == tokenUri
          ? _value.tokenUri
          : tokenUri // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletNftImplCopyWith<$Res>
    implements $WalletNftCopyWith<$Res> {
  factory _$$WalletNftImplCopyWith(
          _$WalletNftImpl value, $Res Function(_$WalletNftImpl) then) =
      __$$WalletNftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String kind,
      String contract,
      String symbol,
      String tokenId,
      String tokenUri});
}

/// @nodoc
class __$$WalletNftImplCopyWithImpl<$Res>
    extends _$WalletNftCopyWithImpl<$Res, _$WalletNftImpl>
    implements _$$WalletNftImplCopyWith<$Res> {
  __$$WalletNftImplCopyWithImpl(
      _$WalletNftImpl _value, $Res Function(_$WalletNftImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletNft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? contract = null,
    Object? symbol = null,
    Object? tokenId = null,
    Object? tokenUri = null,
  }) {
    return _then(_$WalletNftImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      contract: null == contract
          ? _value.contract
          : contract // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: null == tokenId
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenUri: null == tokenUri
          ? _value.tokenUri
          : tokenUri // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletNftImpl implements _WalletNft {
  const _$WalletNftImpl(
      {required this.kind,
      required this.contract,
      required this.symbol,
      required this.tokenId,
      required this.tokenUri});

  factory _$WalletNftImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletNftImplFromJson(json);

  @override
  final String kind;
  @override
  final String contract;
  @override
  final String symbol;
  @override
  final String tokenId;
  @override
  final String tokenUri;

  @override
  String toString() {
    return 'WalletNft(kind: $kind, contract: $contract, symbol: $symbol, tokenId: $tokenId, tokenUri: $tokenUri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletNftImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.contract, contract) ||
                other.contract == contract) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.tokenId, tokenId) || other.tokenId == tokenId) &&
            (identical(other.tokenUri, tokenUri) ||
                other.tokenUri == tokenUri));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, kind, contract, symbol, tokenId, tokenUri);

  /// Create a copy of WalletNft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletNftImplCopyWith<_$WalletNftImpl> get copyWith =>
      __$$WalletNftImplCopyWithImpl<_$WalletNftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletNftImplToJson(
      this,
    );
  }
}

abstract class _WalletNft implements WalletNft {
  const factory _WalletNft(
      {required final String kind,
      required final String contract,
      required final String symbol,
      required final String tokenId,
      required final String tokenUri}) = _$WalletNftImpl;

  factory _WalletNft.fromJson(Map<String, dynamic> json) =
      _$WalletNftImpl.fromJson;

  @override
  String get kind;
  @override
  String get contract;
  @override
  String get symbol;
  @override
  String get tokenId;
  @override
  String get tokenUri;

  /// Create a copy of WalletNft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletNftImplCopyWith<_$WalletNftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
