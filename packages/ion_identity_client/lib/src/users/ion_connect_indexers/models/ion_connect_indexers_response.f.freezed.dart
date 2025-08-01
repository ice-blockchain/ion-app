// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ion_connect_indexers_response.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IONConnectIndexersResponse _$IONConnectIndexersResponseFromJson(
    Map<String, dynamic> json) {
  return _IONConnectIndexersResponse.fromJson(json);
}

/// @nodoc
mixin _$IONConnectIndexersResponse {
  List<String> get ionConnectIndexers => throw _privateConstructorUsedError;

  /// Serializes this IONConnectIndexersResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IONConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IONConnectIndexersResponseCopyWith<IONConnectIndexersResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IONConnectIndexersResponseCopyWith<$Res> {
  factory $IONConnectIndexersResponseCopyWith(IONConnectIndexersResponse value,
          $Res Function(IONConnectIndexersResponse) then) =
      _$IONConnectIndexersResponseCopyWithImpl<$Res,
          IONConnectIndexersResponse>;
  @useResult
  $Res call({List<String> ionConnectIndexers});
}

/// @nodoc
class _$IONConnectIndexersResponseCopyWithImpl<$Res,
        $Val extends IONConnectIndexersResponse>
    implements $IONConnectIndexersResponseCopyWith<$Res> {
  _$IONConnectIndexersResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IONConnectIndexersResponse
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
abstract class _$$IONConnectIndexersResponseImplCopyWith<$Res>
    implements $IONConnectIndexersResponseCopyWith<$Res> {
  factory _$$IONConnectIndexersResponseImplCopyWith(
          _$IONConnectIndexersResponseImpl value,
          $Res Function(_$IONConnectIndexersResponseImpl) then) =
      __$$IONConnectIndexersResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> ionConnectIndexers});
}

/// @nodoc
class __$$IONConnectIndexersResponseImplCopyWithImpl<$Res>
    extends _$IONConnectIndexersResponseCopyWithImpl<$Res,
        _$IONConnectIndexersResponseImpl>
    implements _$$IONConnectIndexersResponseImplCopyWith<$Res> {
  __$$IONConnectIndexersResponseImplCopyWithImpl(
      _$IONConnectIndexersResponseImpl _value,
      $Res Function(_$IONConnectIndexersResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of IONConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ionConnectIndexers = null,
  }) {
    return _then(_$IONConnectIndexersResponseImpl(
      ionConnectIndexers: null == ionConnectIndexers
          ? _value._ionConnectIndexers
          : ionConnectIndexers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IONConnectIndexersResponseImpl implements _IONConnectIndexersResponse {
  const _$IONConnectIndexersResponseImpl(
      {required final List<String> ionConnectIndexers})
      : _ionConnectIndexers = ionConnectIndexers;

  factory _$IONConnectIndexersResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$IONConnectIndexersResponseImplFromJson(json);

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
    return 'IONConnectIndexersResponse(ionConnectIndexers: $ionConnectIndexers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IONConnectIndexersResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._ionConnectIndexers, _ionConnectIndexers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_ionConnectIndexers));

  /// Create a copy of IONConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IONConnectIndexersResponseImplCopyWith<_$IONConnectIndexersResponseImpl>
      get copyWith => __$$IONConnectIndexersResponseImplCopyWithImpl<
          _$IONConnectIndexersResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IONConnectIndexersResponseImplToJson(
      this,
    );
  }
}

abstract class _IONConnectIndexersResponse
    implements IONConnectIndexersResponse {
  const factory _IONConnectIndexersResponse(
          {required final List<String> ionConnectIndexers}) =
      _$IONConnectIndexersResponseImpl;

  factory _IONConnectIndexersResponse.fromJson(Map<String, dynamic> json) =
      _$IONConnectIndexersResponseImpl.fromJson;

  @override
  List<String> get ionConnectIndexers;

  /// Create a copy of IONConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IONConnectIndexersResponseImplCopyWith<_$IONConnectIndexersResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
