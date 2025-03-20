// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_view.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletView _$WalletViewFromJson(Map<String, dynamic> json) {
  return _WalletView.fromJson(json);
}

/// @nodoc
mixin _$WalletView {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @CoinInWalletListConverter()
  List<CoinInWallet> get coins => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: {})
  Map<String, WalletViewAggregationItem> get aggregation =>
      throw _privateConstructorUsedError;
  @JsonKey(defaultValue: [])
  List<String> get symbolGroups => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  List<WalletNft>? get nfts => throw _privateConstructorUsedError;

  /// Serializes this WalletView to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletView
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletViewCopyWith<WalletView> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletViewCopyWith<$Res> {
  factory $WalletViewCopyWith(
          WalletView value, $Res Function(WalletView) then) =
      _$WalletViewCopyWithImpl<$Res, WalletView>;
  @useResult
  $Res call(
      {String id,
      String name,
      @CoinInWalletListConverter() List<CoinInWallet> coins,
      @JsonKey(defaultValue: {})
      Map<String, WalletViewAggregationItem> aggregation,
      @JsonKey(defaultValue: []) List<String> symbolGroups,
      DateTime createdAt,
      DateTime updatedAt,
      String userId,
      List<WalletNft>? nfts});
}

/// @nodoc
class _$WalletViewCopyWithImpl<$Res, $Val extends WalletView>
    implements $WalletViewCopyWith<$Res> {
  _$WalletViewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletView
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? coins = null,
    Object? aggregation = null,
    Object? symbolGroups = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = null,
    Object? nfts = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coins: null == coins
          ? _value.coins
          : coins // ignore: cast_nullable_to_non_nullable
              as List<CoinInWallet>,
      aggregation: null == aggregation
          ? _value.aggregation
          : aggregation // ignore: cast_nullable_to_non_nullable
              as Map<String, WalletViewAggregationItem>,
      symbolGroups: null == symbolGroups
          ? _value.symbolGroups
          : symbolGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nfts: freezed == nfts
          ? _value.nfts
          : nfts // ignore: cast_nullable_to_non_nullable
              as List<WalletNft>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletViewImplCopyWith<$Res>
    implements $WalletViewCopyWith<$Res> {
  factory _$$WalletViewImplCopyWith(
          _$WalletViewImpl value, $Res Function(_$WalletViewImpl) then) =
      __$$WalletViewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @CoinInWalletListConverter() List<CoinInWallet> coins,
      @JsonKey(defaultValue: {})
      Map<String, WalletViewAggregationItem> aggregation,
      @JsonKey(defaultValue: []) List<String> symbolGroups,
      DateTime createdAt,
      DateTime updatedAt,
      String userId,
      List<WalletNft>? nfts});
}

/// @nodoc
class __$$WalletViewImplCopyWithImpl<$Res>
    extends _$WalletViewCopyWithImpl<$Res, _$WalletViewImpl>
    implements _$$WalletViewImplCopyWith<$Res> {
  __$$WalletViewImplCopyWithImpl(
      _$WalletViewImpl _value, $Res Function(_$WalletViewImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletView
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? coins = null,
    Object? aggregation = null,
    Object? symbolGroups = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = null,
    Object? nfts = freezed,
  }) {
    return _then(_$WalletViewImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coins: null == coins
          ? _value._coins
          : coins // ignore: cast_nullable_to_non_nullable
              as List<CoinInWallet>,
      aggregation: null == aggregation
          ? _value._aggregation
          : aggregation // ignore: cast_nullable_to_non_nullable
              as Map<String, WalletViewAggregationItem>,
      symbolGroups: null == symbolGroups
          ? _value._symbolGroups
          : symbolGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nfts: freezed == nfts
          ? _value._nfts
          : nfts // ignore: cast_nullable_to_non_nullable
              as List<WalletNft>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletViewImpl implements _WalletView {
  const _$WalletViewImpl(
      {required this.id,
      required this.name,
      @CoinInWalletListConverter() required final List<CoinInWallet> coins,
      @JsonKey(defaultValue: {})
      required final Map<String, WalletViewAggregationItem> aggregation,
      @JsonKey(defaultValue: []) required final List<String> symbolGroups,
      required this.createdAt,
      required this.updatedAt,
      required this.userId,
      final List<WalletNft>? nfts})
      : _coins = coins,
        _aggregation = aggregation,
        _symbolGroups = symbolGroups,
        _nfts = nfts;

  factory _$WalletViewImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletViewImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<CoinInWallet> _coins;
  @override
  @CoinInWalletListConverter()
  List<CoinInWallet> get coins {
    if (_coins is EqualUnmodifiableListView) return _coins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coins);
  }

  final Map<String, WalletViewAggregationItem> _aggregation;
  @override
  @JsonKey(defaultValue: {})
  Map<String, WalletViewAggregationItem> get aggregation {
    if (_aggregation is EqualUnmodifiableMapView) return _aggregation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_aggregation);
  }

  final List<String> _symbolGroups;
  @override
  @JsonKey(defaultValue: [])
  List<String> get symbolGroups {
    if (_symbolGroups is EqualUnmodifiableListView) return _symbolGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symbolGroups);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String userId;
  final List<WalletNft>? _nfts;
  @override
  List<WalletNft>? get nfts {
    final value = _nfts;
    if (value == null) return null;
    if (_nfts is EqualUnmodifiableListView) return _nfts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'WalletView(id: $id, name: $name, coins: $coins, aggregation: $aggregation, symbolGroups: $symbolGroups, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, nfts: $nfts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletViewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._coins, _coins) &&
            const DeepCollectionEquality()
                .equals(other._aggregation, _aggregation) &&
            const DeepCollectionEquality()
                .equals(other._symbolGroups, _symbolGroups) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._nfts, _nfts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      const DeepCollectionEquality().hash(_coins),
      const DeepCollectionEquality().hash(_aggregation),
      const DeepCollectionEquality().hash(_symbolGroups),
      createdAt,
      updatedAt,
      userId,
      const DeepCollectionEquality().hash(_nfts));

  /// Create a copy of WalletView
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletViewImplCopyWith<_$WalletViewImpl> get copyWith =>
      __$$WalletViewImplCopyWithImpl<_$WalletViewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletViewImplToJson(
      this,
    );
  }
}

abstract class _WalletView implements WalletView {
  const factory _WalletView(
      {required final String id,
      required final String name,
      @CoinInWalletListConverter() required final List<CoinInWallet> coins,
      @JsonKey(defaultValue: {})
      required final Map<String, WalletViewAggregationItem> aggregation,
      @JsonKey(defaultValue: []) required final List<String> symbolGroups,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final String userId,
      final List<WalletNft>? nfts}) = _$WalletViewImpl;

  factory _WalletView.fromJson(Map<String, dynamic> json) =
      _$WalletViewImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @CoinInWalletListConverter()
  List<CoinInWallet> get coins;
  @override
  @JsonKey(defaultValue: {})
  Map<String, WalletViewAggregationItem> get aggregation;
  @override
  @JsonKey(defaultValue: [])
  List<String> get symbolGroups;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String get userId;
  @override
  List<WalletNft>? get nfts;

  /// Create a copy of WalletView
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletViewImplCopyWith<_$WalletViewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
