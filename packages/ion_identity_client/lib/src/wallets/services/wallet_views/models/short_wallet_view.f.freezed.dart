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

ShortWalletView _$ShortWalletViewFromJson(Map<String, dynamic> json) {
  return _ShortWalletView.fromJson(json);
}

/// @nodoc
mixin _$ShortWalletView {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: [])
  List<WalletViewCoinData> get coins => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: [])
  List<String> get symbolGroups => throw _privateConstructorUsedError;

  /// Serializes this ShortWalletView to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShortWalletView
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShortWalletViewCopyWith<ShortWalletView> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShortWalletViewCopyWith<$Res> {
  factory $ShortWalletViewCopyWith(
          ShortWalletView value, $Res Function(ShortWalletView) then) =
      _$ShortWalletViewCopyWithImpl<$Res, ShortWalletView>;
  @useResult
  $Res call(
      {String name,
      @JsonKey(defaultValue: []) List<WalletViewCoinData> coins,
      String createdAt,
      String updatedAt,
      String userId,
      String id,
      @JsonKey(defaultValue: []) List<String> symbolGroups});
}

/// @nodoc
class _$ShortWalletViewCopyWithImpl<$Res, $Val extends ShortWalletView>
    implements $ShortWalletViewCopyWith<$Res> {
  _$ShortWalletViewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShortWalletView
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? coins = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = null,
    Object? id = null,
    Object? symbolGroups = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coins: null == coins
          ? _value.coins
          : coins // ignore: cast_nullable_to_non_nullable
              as List<WalletViewCoinData>,
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
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbolGroups: null == symbolGroups
          ? _value.symbolGroups
          : symbolGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShortWalletViewImplCopyWith<$Res>
    implements $ShortWalletViewCopyWith<$Res> {
  factory _$$ShortWalletViewImplCopyWith(_$ShortWalletViewImpl value,
          $Res Function(_$ShortWalletViewImpl) then) =
      __$$ShortWalletViewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      @JsonKey(defaultValue: []) List<WalletViewCoinData> coins,
      String createdAt,
      String updatedAt,
      String userId,
      String id,
      @JsonKey(defaultValue: []) List<String> symbolGroups});
}

/// @nodoc
class __$$ShortWalletViewImplCopyWithImpl<$Res>
    extends _$ShortWalletViewCopyWithImpl<$Res, _$ShortWalletViewImpl>
    implements _$$ShortWalletViewImplCopyWith<$Res> {
  __$$ShortWalletViewImplCopyWithImpl(
      _$ShortWalletViewImpl _value, $Res Function(_$ShortWalletViewImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShortWalletView
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? coins = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = null,
    Object? id = null,
    Object? symbolGroups = null,
  }) {
    return _then(_$ShortWalletViewImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coins: null == coins
          ? _value._coins
          : coins // ignore: cast_nullable_to_non_nullable
              as List<WalletViewCoinData>,
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
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbolGroups: null == symbolGroups
          ? _value._symbolGroups
          : symbolGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShortWalletViewImpl implements _ShortWalletView {
  const _$ShortWalletViewImpl(
      {required this.name,
      @JsonKey(defaultValue: []) required final List<WalletViewCoinData> coins,
      required this.createdAt,
      required this.updatedAt,
      required this.userId,
      required this.id,
      @JsonKey(defaultValue: []) required final List<String> symbolGroups})
      : _coins = coins,
        _symbolGroups = symbolGroups;

  factory _$ShortWalletViewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShortWalletViewImplFromJson(json);

  @override
  final String name;
  final List<WalletViewCoinData> _coins;
  @override
  @JsonKey(defaultValue: [])
  List<WalletViewCoinData> get coins {
    if (_coins is EqualUnmodifiableListView) return _coins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coins);
  }

  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final String userId;
  @override
  final String id;
  final List<String> _symbolGroups;
  @override
  @JsonKey(defaultValue: [])
  List<String> get symbolGroups {
    if (_symbolGroups is EqualUnmodifiableListView) return _symbolGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symbolGroups);
  }

  @override
  String toString() {
    return 'ShortWalletView(name: $name, coins: $coins, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, id: $id, symbolGroups: $symbolGroups)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShortWalletViewImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._coins, _coins) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._symbolGroups, _symbolGroups));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      const DeepCollectionEquality().hash(_coins),
      createdAt,
      updatedAt,
      userId,
      id,
      const DeepCollectionEquality().hash(_symbolGroups));

  /// Create a copy of ShortWalletView
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShortWalletViewImplCopyWith<_$ShortWalletViewImpl> get copyWith =>
      __$$ShortWalletViewImplCopyWithImpl<_$ShortWalletViewImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShortWalletViewImplToJson(
      this,
    );
  }
}

abstract class _ShortWalletView implements ShortWalletView {
  const factory _ShortWalletView(
      {required final String name,
      @JsonKey(defaultValue: []) required final List<WalletViewCoinData> coins,
      required final String createdAt,
      required final String updatedAt,
      required final String userId,
      required final String id,
      @JsonKey(defaultValue: [])
      required final List<String> symbolGroups}) = _$ShortWalletViewImpl;

  factory _ShortWalletView.fromJson(Map<String, dynamic> json) =
      _$ShortWalletViewImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(defaultValue: [])
  List<WalletViewCoinData> get coins;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  String get userId;
  @override
  String get id;
  @override
  @JsonKey(defaultValue: [])
  List<String> get symbolGroups;

  /// Create a copy of ShortWalletView
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShortWalletViewImplCopyWith<_$ShortWalletViewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
