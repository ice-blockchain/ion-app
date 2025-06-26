// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_ion_connect_relays_response.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SetIONConnectRelaysResponse _$SetIONConnectRelaysResponseFromJson(
    Map<String, dynamic> json) {
  return _SetIONConnectRelaysResponse.fromJson(json);
}

/// @nodoc
mixin _$SetIONConnectRelaysResponse {
  List<String> get ionConnectRelays => throw _privateConstructorUsedError;

  /// Serializes this SetIONConnectRelaysResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SetIONConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetIONConnectRelaysResponseCopyWith<SetIONConnectRelaysResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetIONConnectRelaysResponseCopyWith<$Res> {
  factory $SetIONConnectRelaysResponseCopyWith(
          SetIONConnectRelaysResponse value,
          $Res Function(SetIONConnectRelaysResponse) then) =
      _$SetIONConnectRelaysResponseCopyWithImpl<$Res,
          SetIONConnectRelaysResponse>;
  @useResult
  $Res call({List<String> ionConnectRelays});
}

/// @nodoc
class _$SetIONConnectRelaysResponseCopyWithImpl<$Res,
        $Val extends SetIONConnectRelaysResponse>
    implements $SetIONConnectRelaysResponseCopyWith<$Res> {
  _$SetIONConnectRelaysResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetIONConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ionConnectRelays = null,
  }) {
    return _then(_value.copyWith(
      ionConnectRelays: null == ionConnectRelays
          ? _value.ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SetIONConnectRelaysResponseImplCopyWith<$Res>
    implements $SetIONConnectRelaysResponseCopyWith<$Res> {
  factory _$$SetIONConnectRelaysResponseImplCopyWith(
          _$SetIONConnectRelaysResponseImpl value,
          $Res Function(_$SetIONConnectRelaysResponseImpl) then) =
      __$$SetIONConnectRelaysResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> ionConnectRelays});
}

/// @nodoc
class __$$SetIONConnectRelaysResponseImplCopyWithImpl<$Res>
    extends _$SetIONConnectRelaysResponseCopyWithImpl<$Res,
        _$SetIONConnectRelaysResponseImpl>
    implements _$$SetIONConnectRelaysResponseImplCopyWith<$Res> {
  __$$SetIONConnectRelaysResponseImplCopyWithImpl(
      _$SetIONConnectRelaysResponseImpl _value,
      $Res Function(_$SetIONConnectRelaysResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SetIONConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ionConnectRelays = null,
  }) {
    return _then(_$SetIONConnectRelaysResponseImpl(
      ionConnectRelays: null == ionConnectRelays
          ? _value._ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetIONConnectRelaysResponseImpl
    implements _SetIONConnectRelaysResponse {
  const _$SetIONConnectRelaysResponseImpl(
      {required final List<String> ionConnectRelays})
      : _ionConnectRelays = ionConnectRelays;

  factory _$SetIONConnectRelaysResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SetIONConnectRelaysResponseImplFromJson(json);

  final List<String> _ionConnectRelays;
  @override
  List<String> get ionConnectRelays {
    if (_ionConnectRelays is EqualUnmodifiableListView)
      return _ionConnectRelays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ionConnectRelays);
  }

  @override
  String toString() {
    return 'SetIONConnectRelaysResponse(ionConnectRelays: $ionConnectRelays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetIONConnectRelaysResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._ionConnectRelays, _ionConnectRelays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_ionConnectRelays));

  /// Create a copy of SetIONConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetIONConnectRelaysResponseImplCopyWith<_$SetIONConnectRelaysResponseImpl>
      get copyWith => __$$SetIONConnectRelaysResponseImplCopyWithImpl<
          _$SetIONConnectRelaysResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetIONConnectRelaysResponseImplToJson(
      this,
    );
  }
}

abstract class _SetIONConnectRelaysResponse
    implements SetIONConnectRelaysResponse {
  const factory _SetIONConnectRelaysResponse(
          {required final List<String> ionConnectRelays}) =
      _$SetIONConnectRelaysResponseImpl;

  factory _SetIONConnectRelaysResponse.fromJson(Map<String, dynamic> json) =
      _$SetIONConnectRelaysResponseImpl.fromJson;

  @override
  List<String> get ionConnectRelays;

  /// Create a copy of SetIONConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetIONConnectRelaysResponseImplCopyWith<_$SetIONConnectRelaysResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
