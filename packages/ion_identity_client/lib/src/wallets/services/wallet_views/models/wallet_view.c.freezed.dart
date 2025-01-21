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
  String get name => throw _privateConstructorUsedError;
  List<Coin> get coins => throw _privateConstructorUsedError;
  Map<String, WalletViewAggregationItem> get aggregation =>
      throw _privateConstructorUsedError;
  List<String> get symbolGroups => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

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
      {String name,
      List<Coin> coins,
      Map<String, WalletViewAggregationItem> aggregation,
      List<String> symbolGroups,
      String createdAt,
      String updatedAt,
      String userId});
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
    Object? name = null,
    Object? coins = null,
    Object? aggregation = null,
    Object? symbolGroups = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coins: null == coins
          ? _value.coins
          : coins // ignore: cast_nullable_to_non_nullable
              as List<Coin>,
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
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
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
      {String name,
      List<Coin> coins,
      Map<String, WalletViewAggregationItem> aggregation,
      List<String> symbolGroups,
      String createdAt,
      String updatedAt,
      String userId});
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
    Object? name = null,
    Object? coins = null,
    Object? aggregation = null,
    Object? symbolGroups = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = null,
  }) {
    return _then(_$WalletViewImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coins: null == coins
          ? _value._coins
          : coins // ignore: cast_nullable_to_non_nullable
              as List<Coin>,
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
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletViewImpl implements _WalletView {
  const _$WalletViewImpl(
      {required this.name,
      required final List<Coin> coins,
      required final Map<String, WalletViewAggregationItem> aggregation,
      required final List<String> symbolGroups,
      required this.createdAt,
      required this.updatedAt,
      required this.userId})
      : _coins = coins,
        _aggregation = aggregation,
        _symbolGroups = symbolGroups;

  factory _$WalletViewImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletViewImplFromJson(json);

  @override
  final String name;
  final List<Coin> _coins;
  @override
  List<Coin> get coins {
    if (_coins is EqualUnmodifiableListView) return _coins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coins);
  }

  final Map<String, WalletViewAggregationItem> _aggregation;
  @override
  Map<String, WalletViewAggregationItem> get aggregation {
    if (_aggregation is EqualUnmodifiableMapView) return _aggregation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_aggregation);
  }

  final List<String> _symbolGroups;
  @override
  List<String> get symbolGroups {
    if (_symbolGroups is EqualUnmodifiableListView) return _symbolGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symbolGroups);
  }

  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final String userId;

  @override
  String toString() {
    return 'WalletView(name: $name, coins: $coins, aggregation: $aggregation, symbolGroups: $symbolGroups, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletViewImpl &&
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
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      const DeepCollectionEquality().hash(_coins),
      const DeepCollectionEquality().hash(_aggregation),
      const DeepCollectionEquality().hash(_symbolGroups),
      createdAt,
      updatedAt,
      userId);

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
      {required final String name,
      required final List<Coin> coins,
      required final Map<String, WalletViewAggregationItem> aggregation,
      required final List<String> symbolGroups,
      required final String createdAt,
      required final String updatedAt,
      required final String userId}) = _$WalletViewImpl;

  factory _WalletView.fromJson(Map<String, dynamic> json) =
      _$WalletViewImpl.fromJson;

  @override
  String get name;
  @override
  List<Coin> get coins;
  @override
  Map<String, WalletViewAggregationItem> get aggregation;
  @override
  List<String> get symbolGroups;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  String get userId;

  /// Create a copy of WalletView
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletViewImplCopyWith<_$WalletViewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
