// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_keys_response.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListKeysResponse _$ListKeysResponseFromJson(Map<String, dynamic> json) {
  return _ListKeysResponse.fromJson(json);
}

/// @nodoc
mixin _$ListKeysResponse {
  List<KeyResponse> get items => throw _privateConstructorUsedError;
  String? get nextPageToken => throw _privateConstructorUsedError;

  /// Serializes this ListKeysResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ListKeysResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListKeysResponseCopyWith<ListKeysResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListKeysResponseCopyWith<$Res> {
  factory $ListKeysResponseCopyWith(
          ListKeysResponse value, $Res Function(ListKeysResponse) then) =
      _$ListKeysResponseCopyWithImpl<$Res, ListKeysResponse>;
  @useResult
  $Res call({List<KeyResponse> items, String? nextPageToken});
}

/// @nodoc
class _$ListKeysResponseCopyWithImpl<$Res, $Val extends ListKeysResponse>
    implements $ListKeysResponseCopyWith<$Res> {
  _$ListKeysResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListKeysResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextPageToken = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<KeyResponse>,
      nextPageToken: freezed == nextPageToken
          ? _value.nextPageToken
          : nextPageToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListKeysResponseImplCopyWith<$Res>
    implements $ListKeysResponseCopyWith<$Res> {
  factory _$$ListKeysResponseImplCopyWith(_$ListKeysResponseImpl value,
          $Res Function(_$ListKeysResponseImpl) then) =
      __$$ListKeysResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<KeyResponse> items, String? nextPageToken});
}

/// @nodoc
class __$$ListKeysResponseImplCopyWithImpl<$Res>
    extends _$ListKeysResponseCopyWithImpl<$Res, _$ListKeysResponseImpl>
    implements _$$ListKeysResponseImplCopyWith<$Res> {
  __$$ListKeysResponseImplCopyWithImpl(_$ListKeysResponseImpl _value,
      $Res Function(_$ListKeysResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListKeysResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextPageToken = freezed,
  }) {
    return _then(_$ListKeysResponseImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<KeyResponse>,
      nextPageToken: freezed == nextPageToken
          ? _value.nextPageToken
          : nextPageToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListKeysResponseImpl implements _ListKeysResponse {
  _$ListKeysResponseImpl(
      {required final List<KeyResponse> items, this.nextPageToken})
      : _items = items;

  factory _$ListKeysResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListKeysResponseImplFromJson(json);

  final List<KeyResponse> _items;
  @override
  List<KeyResponse> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextPageToken;

  @override
  String toString() {
    return 'ListKeysResponse(items: $items, nextPageToken: $nextPageToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListKeysResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextPageToken, nextPageToken) ||
                other.nextPageToken == nextPageToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextPageToken);

  /// Create a copy of ListKeysResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListKeysResponseImplCopyWith<_$ListKeysResponseImpl> get copyWith =>
      __$$ListKeysResponseImplCopyWithImpl<_$ListKeysResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListKeysResponseImplToJson(
      this,
    );
  }
}

abstract class _ListKeysResponse implements ListKeysResponse {
  factory _ListKeysResponse(
      {required final List<KeyResponse> items,
      final String? nextPageToken}) = _$ListKeysResponseImpl;

  factory _ListKeysResponse.fromJson(Map<String, dynamic> json) =
      _$ListKeysResponseImpl.fromJson;

  @override
  List<KeyResponse> get items;
  @override
  String? get nextPageToken;

  /// Create a copy of ListKeysResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListKeysResponseImplCopyWith<_$ListKeysResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
