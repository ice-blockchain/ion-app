// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_connect_indexers_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUserConnectIndexersResponse _$GetUserConnectIndexersResponseFromJson(
    Map<String, dynamic> json) {
  return _GetUserConnectIndexersResponse.fromJson(json);
}

/// @nodoc
mixin _$GetUserConnectIndexersResponse {
  List<String> get ionConnectIndexers => throw _privateConstructorUsedError;

  /// Serializes this GetUserConnectIndexersResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetUserConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetUserConnectIndexersResponseCopyWith<GetUserConnectIndexersResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserConnectIndexersResponseCopyWith<$Res> {
  factory $GetUserConnectIndexersResponseCopyWith(
          GetUserConnectIndexersResponse value,
          $Res Function(GetUserConnectIndexersResponse) then) =
      _$GetUserConnectIndexersResponseCopyWithImpl<$Res,
          GetUserConnectIndexersResponse>;
  @useResult
  $Res call({List<String> ionConnectIndexers});
}

/// @nodoc
class _$GetUserConnectIndexersResponseCopyWithImpl<$Res,
        $Val extends GetUserConnectIndexersResponse>
    implements $GetUserConnectIndexersResponseCopyWith<$Res> {
  _$GetUserConnectIndexersResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetUserConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ionConnectIndexers = null,
  }) {
    return _then(_value.copyWith(
      ionConnectIndexers: null == ionConnectIndexers
          ? _value.ionConnectIndexers
          : ionConnectIndexers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetUserConnectIndexersResponseImplCopyWith<$Res>
    implements $GetUserConnectIndexersResponseCopyWith<$Res> {
  factory _$$GetUserConnectIndexersResponseImplCopyWith(
          _$GetUserConnectIndexersResponseImpl value,
          $Res Function(_$GetUserConnectIndexersResponseImpl) then) =
      __$$GetUserConnectIndexersResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> ionConnectIndexers});
}

/// @nodoc
class __$$GetUserConnectIndexersResponseImplCopyWithImpl<$Res>
    extends _$GetUserConnectIndexersResponseCopyWithImpl<$Res,
        _$GetUserConnectIndexersResponseImpl>
    implements _$$GetUserConnectIndexersResponseImplCopyWith<$Res> {
  __$$GetUserConnectIndexersResponseImplCopyWithImpl(
      _$GetUserConnectIndexersResponseImpl _value,
      $Res Function(_$GetUserConnectIndexersResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetUserConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ionConnectIndexers = null,
  }) {
    return _then(_$GetUserConnectIndexersResponseImpl(
      ionConnectIndexers: null == ionConnectIndexers
          ? _value._ionConnectIndexers
          : ionConnectIndexers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUserConnectIndexersResponseImpl
    implements _GetUserConnectIndexersResponse {
  const _$GetUserConnectIndexersResponseImpl(
      {required final List<String> ionConnectIndexers})
      : _ionConnectIndexers = ionConnectIndexers;

  factory _$GetUserConnectIndexersResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$GetUserConnectIndexersResponseImplFromJson(json);

  final List<String> _ionConnectIndexers;
  @override
  List<String> get ionConnectIndexers {
    if (_ionConnectIndexers is EqualUnmodifiableListView)
      return _ionConnectIndexers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ionConnectIndexers);
  }

  @override
  String toString() {
    return 'GetUserConnectIndexersResponse(ionConnectIndexers: $ionConnectIndexers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserConnectIndexersResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._ionConnectIndexers, _ionConnectIndexers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_ionConnectIndexers));

  /// Create a copy of GetUserConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserConnectIndexersResponseImplCopyWith<
          _$GetUserConnectIndexersResponseImpl>
      get copyWith => __$$GetUserConnectIndexersResponseImplCopyWithImpl<
          _$GetUserConnectIndexersResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserConnectIndexersResponseImplToJson(
      this,
    );
  }
}

abstract class _GetUserConnectIndexersResponse
    implements GetUserConnectIndexersResponse {
  const factory _GetUserConnectIndexersResponse(
          {required final List<String> ionConnectIndexers}) =
      _$GetUserConnectIndexersResponseImpl;

  factory _GetUserConnectIndexersResponse.fromJson(Map<String, dynamic> json) =
      _$GetUserConnectIndexersResponseImpl.fromJson;

  @override
  List<String> get ionConnectIndexers;

  /// Create a copy of GetUserConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetUserConnectIndexersResponseImplCopyWith<
          _$GetUserConnectIndexersResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
