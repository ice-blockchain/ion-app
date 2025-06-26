// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_update_wallet_view_request.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateUpdateWalletViewRequest _$CreateUpdateWalletViewRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateWalletViewRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateUpdateWalletViewRequest {
  List<WalletViewCoinData> get items => throw _privateConstructorUsedError;
  List<String> get symbolGroups => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this CreateUpdateWalletViewRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateUpdateWalletViewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateUpdateWalletViewRequestCopyWith<CreateUpdateWalletViewRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateUpdateWalletViewRequestCopyWith<$Res> {
  factory $CreateUpdateWalletViewRequestCopyWith(
          CreateUpdateWalletViewRequest value,
          $Res Function(CreateUpdateWalletViewRequest) then) =
      _$CreateUpdateWalletViewRequestCopyWithImpl<$Res,
          CreateUpdateWalletViewRequest>;
  @useResult
  $Res call(
      {List<WalletViewCoinData> items, List<String> symbolGroups, String name});
}

/// @nodoc
class _$CreateUpdateWalletViewRequestCopyWithImpl<$Res,
        $Val extends CreateUpdateWalletViewRequest>
    implements $CreateUpdateWalletViewRequestCopyWith<$Res> {
  _$CreateUpdateWalletViewRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateUpdateWalletViewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? symbolGroups = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WalletViewCoinData>,
      symbolGroups: null == symbolGroups
          ? _value.symbolGroups
          : symbolGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateWalletViewRequestImplCopyWith<$Res>
    implements $CreateUpdateWalletViewRequestCopyWith<$Res> {
  factory _$$CreateWalletViewRequestImplCopyWith(
          _$CreateWalletViewRequestImpl value,
          $Res Function(_$CreateWalletViewRequestImpl) then) =
      __$$CreateWalletViewRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WalletViewCoinData> items, List<String> symbolGroups, String name});
}

/// @nodoc
class __$$CreateWalletViewRequestImplCopyWithImpl<$Res>
    extends _$CreateUpdateWalletViewRequestCopyWithImpl<$Res,
        _$CreateWalletViewRequestImpl>
    implements _$$CreateWalletViewRequestImplCopyWith<$Res> {
  __$$CreateWalletViewRequestImplCopyWithImpl(
      _$CreateWalletViewRequestImpl _value,
      $Res Function(_$CreateWalletViewRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateUpdateWalletViewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? symbolGroups = null,
    Object? name = null,
  }) {
    return _then(_$CreateWalletViewRequestImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WalletViewCoinData>,
      symbolGroups: null == symbolGroups
          ? _value._symbolGroups
          : symbolGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateWalletViewRequestImpl implements _CreateWalletViewRequest {
  const _$CreateWalletViewRequestImpl(
      {required final List<WalletViewCoinData> items,
      required final List<String> symbolGroups,
      required this.name})
      : _items = items,
        _symbolGroups = symbolGroups;

  factory _$CreateWalletViewRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateWalletViewRequestImplFromJson(json);

  final List<WalletViewCoinData> _items;
  @override
  List<WalletViewCoinData> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<String> _symbolGroups;
  @override
  List<String> get symbolGroups {
    if (_symbolGroups is EqualUnmodifiableListView) return _symbolGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symbolGroups);
  }

  @override
  final String name;

  @override
  String toString() {
    return 'CreateUpdateWalletViewRequest(items: $items, symbolGroups: $symbolGroups, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateWalletViewRequestImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._symbolGroups, _symbolGroups) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_symbolGroups),
      name);

  /// Create a copy of CreateUpdateWalletViewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateWalletViewRequestImplCopyWith<_$CreateWalletViewRequestImpl>
      get copyWith => __$$CreateWalletViewRequestImplCopyWithImpl<
          _$CreateWalletViewRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateWalletViewRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateWalletViewRequest
    implements CreateUpdateWalletViewRequest {
  const factory _CreateWalletViewRequest(
      {required final List<WalletViewCoinData> items,
      required final List<String> symbolGroups,
      required final String name}) = _$CreateWalletViewRequestImpl;

  factory _CreateWalletViewRequest.fromJson(Map<String, dynamic> json) =
      _$CreateWalletViewRequestImpl.fromJson;

  @override
  List<WalletViewCoinData> get items;
  @override
  List<String> get symbolGroups;
  @override
  String get name;

  /// Create a copy of CreateUpdateWalletViewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateWalletViewRequestImplCopyWith<_$CreateWalletViewRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
