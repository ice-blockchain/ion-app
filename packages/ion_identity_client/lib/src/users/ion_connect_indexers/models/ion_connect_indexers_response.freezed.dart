// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ion_connect_indexers_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IonConnectIndexersResponse _$IonConnectIndexersResponseFromJson(
    Map<String, dynamic> json) {
  return _IonConnectIndexersResponse.fromJson(json);
}

/// @nodoc
mixin _$IonConnectIndexersResponse {
  List<String> get ionConnectIndexers => throw _privateConstructorUsedError;

  /// Serializes this IonConnectIndexersResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IonConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IonConnectIndexersResponseCopyWith<IonConnectIndexersResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IonConnectIndexersResponseCopyWith<$Res> {
  factory $IonConnectIndexersResponseCopyWith(IonConnectIndexersResponse value,
          $Res Function(IonConnectIndexersResponse) then) =
      _$IonConnectIndexersResponseCopyWithImpl<$Res,
          IonConnectIndexersResponse>;
  @useResult
  $Res call({List<String> ionConnectIndexers});
}

/// @nodoc
class _$IonConnectIndexersResponseCopyWithImpl<$Res,
        $Val extends IonConnectIndexersResponse>
    implements $IonConnectIndexersResponseCopyWith<$Res> {
  _$IonConnectIndexersResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IonConnectIndexersResponse
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
abstract class _$$IonConnectIndexersResponseImplCopyWith<$Res>
    implements $IonConnectIndexersResponseCopyWith<$Res> {
  factory _$$IonConnectIndexersResponseImplCopyWith(
          _$IonConnectIndexersResponseImpl value,
          $Res Function(_$IonConnectIndexersResponseImpl) then) =
      __$$IonConnectIndexersResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> ionConnectIndexers});
}

/// @nodoc
class __$$IonConnectIndexersResponseImplCopyWithImpl<$Res>
    extends _$IonConnectIndexersResponseCopyWithImpl<$Res,
        _$IonConnectIndexersResponseImpl>
    implements _$$IonConnectIndexersResponseImplCopyWith<$Res> {
  __$$IonConnectIndexersResponseImplCopyWithImpl(
      _$IonConnectIndexersResponseImpl _value,
      $Res Function(_$IonConnectIndexersResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of IonConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ionConnectIndexers = null,
  }) {
    return _then(_$IonConnectIndexersResponseImpl(
      ionConnectIndexers: null == ionConnectIndexers
          ? _value._ionConnectIndexers
          : ionConnectIndexers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IonConnectIndexersResponseImpl implements _IonConnectIndexersResponse {
  const _$IonConnectIndexersResponseImpl(
      {required final List<String> ionConnectIndexers})
      : _ionConnectIndexers = ionConnectIndexers;

  factory _$IonConnectIndexersResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$IonConnectIndexersResponseImplFromJson(json);

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
    return 'IonConnectIndexersResponse(ionConnectIndexers: $ionConnectIndexers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IonConnectIndexersResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._ionConnectIndexers, _ionConnectIndexers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_ionConnectIndexers));

  /// Create a copy of IonConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IonConnectIndexersResponseImplCopyWith<_$IonConnectIndexersResponseImpl>
      get copyWith => __$$IonConnectIndexersResponseImplCopyWithImpl<
          _$IonConnectIndexersResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IonConnectIndexersResponseImplToJson(
      this,
    );
  }
}

abstract class _IonConnectIndexersResponse
    implements IonConnectIndexersResponse {
  const factory _IonConnectIndexersResponse(
          {required final List<String> ionConnectIndexers}) =
      _$IonConnectIndexersResponseImpl;

  factory _IonConnectIndexersResponse.fromJson(Map<String, dynamic> json) =
      _$IonConnectIndexersResponseImpl.fromJson;

  @override
  List<String> get ionConnectIndexers;

  /// Create a copy of IonConnectIndexersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IonConnectIndexersResponseImplCopyWith<_$IonConnectIndexersResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
