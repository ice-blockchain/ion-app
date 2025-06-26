// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_wallets_response.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetWalletsResponse _$GetWalletsResponseFromJson(Map<String, dynamic> json) {
  return _GetWalletsResponse.fromJson(json);
}

/// @nodoc
mixin _$GetWalletsResponse {
  List<Wallet> get items => throw _privateConstructorUsedError;

  /// Serializes this GetWalletsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetWalletsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetWalletsResponseCopyWith<GetWalletsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetWalletsResponseCopyWith<$Res> {
  factory $GetWalletsResponseCopyWith(
          GetWalletsResponse value, $Res Function(GetWalletsResponse) then) =
      _$GetWalletsResponseCopyWithImpl<$Res, GetWalletsResponse>;
  @useResult
  $Res call({List<Wallet> items});
}

/// @nodoc
class _$GetWalletsResponseCopyWithImpl<$Res, $Val extends GetWalletsResponse>
    implements $GetWalletsResponseCopyWith<$Res> {
  _$GetWalletsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetWalletsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Wallet>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetWalletsResponseImplCopyWith<$Res>
    implements $GetWalletsResponseCopyWith<$Res> {
  factory _$$GetWalletsResponseImplCopyWith(_$GetWalletsResponseImpl value,
          $Res Function(_$GetWalletsResponseImpl) then) =
      __$$GetWalletsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Wallet> items});
}

/// @nodoc
class __$$GetWalletsResponseImplCopyWithImpl<$Res>
    extends _$GetWalletsResponseCopyWithImpl<$Res, _$GetWalletsResponseImpl>
    implements _$$GetWalletsResponseImplCopyWith<$Res> {
  __$$GetWalletsResponseImplCopyWithImpl(_$GetWalletsResponseImpl _value,
      $Res Function(_$GetWalletsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetWalletsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_$GetWalletsResponseImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Wallet>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetWalletsResponseImpl implements _GetWalletsResponse {
  _$GetWalletsResponseImpl({required final List<Wallet> items})
      : _items = items;

  factory _$GetWalletsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetWalletsResponseImplFromJson(json);

  final List<Wallet> _items;
  @override
  List<Wallet> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'GetWalletsResponse(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetWalletsResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of GetWalletsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetWalletsResponseImplCopyWith<_$GetWalletsResponseImpl> get copyWith =>
      __$$GetWalletsResponseImplCopyWithImpl<_$GetWalletsResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetWalletsResponseImplToJson(
      this,
    );
  }
}

abstract class _GetWalletsResponse implements GetWalletsResponse {
  factory _GetWalletsResponse({required final List<Wallet> items}) =
      _$GetWalletsResponseImpl;

  factory _GetWalletsResponse.fromJson(Map<String, dynamic> json) =
      _$GetWalletsResponseImpl.fromJson;

  @override
  List<Wallet> get items;

  /// Create a copy of GetWalletsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetWalletsResponseImplCopyWith<_$GetWalletsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
