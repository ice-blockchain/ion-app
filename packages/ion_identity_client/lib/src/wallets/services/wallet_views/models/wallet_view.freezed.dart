// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'short_wallet_view.f.dart';

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
  Map<String, WalletViewCoinData> get coins =>
      throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  List<WalletViewItem> get items => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
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
      {Map<String, WalletViewCoinData> coins,
      String createdAt,
      List<WalletViewItem> items,
      String name,
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
    Object? coins = null,
    Object? createdAt = null,
    Object? items = null,
    Object? name = null,
    Object? updatedAt = null,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      coins: null == coins
          ? _value.coins
          : coins // ignore: cast_nullable_to_non_nullable
              as Map<String, WalletViewCoinData>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WalletViewItem>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
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
      {Map<String, WalletViewCoinData> coins,
      String createdAt,
      List<WalletViewItem> items,
      String name,
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
    Object? coins = null,
    Object? createdAt = null,
    Object? items = null,
    Object? name = null,
    Object? updatedAt = null,
    Object? userId = null,
  }) {
    return _then(_$WalletViewImpl(
      coins: null == coins
          ? _value._coins
          : coins // ignore: cast_nullable_to_non_nullable
              as Map<String, WalletViewCoinData>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WalletViewItem>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
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
      {required final Map<String, WalletViewCoinData> coins,
      required this.createdAt,
      required final List<WalletViewItem> items,
      required this.name,
      required this.updatedAt,
      required this.userId})
      : _coins = coins,
        _items = items;

  factory _$WalletViewImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletViewImplFromJson(json);

  final Map<String, WalletViewCoinData> _coins;
  @override
  Map<String, WalletViewCoinData> get coins {
    if (_coins is EqualUnmodifiableMapView) return _coins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_coins);
  }

  @override
  final String createdAt;
  final List<WalletViewItem> _items;
  @override
  List<WalletViewItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String name;
  @override
  final String updatedAt;
  @override
  final String userId;

  @override
  String toString() {
    return 'WalletView(coins: $coins, createdAt: $createdAt, items: $items, name: $name, updatedAt: $updatedAt, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletViewImpl &&
            const DeepCollectionEquality().equals(other._coins, _coins) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_coins),
      createdAt,
      const DeepCollectionEquality().hash(_items),
      name,
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
      {required final Map<String, WalletViewCoinData> coins,
      required final String createdAt,
      required final List<WalletViewItem> items,
      required final String name,
      required final String updatedAt,
      required final String userId}) = _$WalletViewImpl;

  factory _WalletView.fromJson(Map<String, dynamic> json) =
      _$WalletViewImpl.fromJson;

  @override
  Map<String, WalletViewCoinData> get coins;
  @override
  String get createdAt;
  @override
  List<WalletViewItem> get items;
  @override
  String get name;
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
