// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_user_connect_relays_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SetUserConnectRelaysResponse _$SetUserConnectRelaysResponseFromJson(
    Map<String, dynamic> json) {
  return _SetUserConnectRelaysResponse.fromJson(json);
}

/// @nodoc
mixin _$SetUserConnectRelaysResponse {
  List<String> get ionConnectRelays => throw _privateConstructorUsedError;

  /// Serializes this SetUserConnectRelaysResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SetUserConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetUserConnectRelaysResponseCopyWith<SetUserConnectRelaysResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetUserConnectRelaysResponseCopyWith<$Res> {
  factory $SetUserConnectRelaysResponseCopyWith(
          SetUserConnectRelaysResponse value,
          $Res Function(SetUserConnectRelaysResponse) then) =
      _$SetUserConnectRelaysResponseCopyWithImpl<$Res,
          SetUserConnectRelaysResponse>;
  @useResult
  $Res call({List<String> ionConnectRelays});
}

/// @nodoc
class _$SetUserConnectRelaysResponseCopyWithImpl<$Res,
        $Val extends SetUserConnectRelaysResponse>
    implements $SetUserConnectRelaysResponseCopyWith<$Res> {
  _$SetUserConnectRelaysResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetUserConnectRelaysResponse
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
abstract class _$$SetUserConnectRelaysResponseImplCopyWith<$Res>
    implements $SetUserConnectRelaysResponseCopyWith<$Res> {
  factory _$$SetUserConnectRelaysResponseImplCopyWith(
          _$SetUserConnectRelaysResponseImpl value,
          $Res Function(_$SetUserConnectRelaysResponseImpl) then) =
      __$$SetUserConnectRelaysResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> ionConnectRelays});
}

/// @nodoc
class __$$SetUserConnectRelaysResponseImplCopyWithImpl<$Res>
    extends _$SetUserConnectRelaysResponseCopyWithImpl<$Res,
        _$SetUserConnectRelaysResponseImpl>
    implements _$$SetUserConnectRelaysResponseImplCopyWith<$Res> {
  __$$SetUserConnectRelaysResponseImplCopyWithImpl(
      _$SetUserConnectRelaysResponseImpl _value,
      $Res Function(_$SetUserConnectRelaysResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SetUserConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ionConnectRelays = null,
  }) {
    return _then(_$SetUserConnectRelaysResponseImpl(
      ionConnectRelays: null == ionConnectRelays
          ? _value._ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetUserConnectRelaysResponseImpl
    implements _SetUserConnectRelaysResponse {
  const _$SetUserConnectRelaysResponseImpl(
      {required final List<String> ionConnectRelays})
      : _ionConnectRelays = ionConnectRelays;

  factory _$SetUserConnectRelaysResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SetUserConnectRelaysResponseImplFromJson(json);

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
    return 'SetUserConnectRelaysResponse(ionConnectRelays: $ionConnectRelays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetUserConnectRelaysResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._ionConnectRelays, _ionConnectRelays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_ionConnectRelays));

  /// Create a copy of SetUserConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetUserConnectRelaysResponseImplCopyWith<
          _$SetUserConnectRelaysResponseImpl>
      get copyWith => __$$SetUserConnectRelaysResponseImplCopyWithImpl<
          _$SetUserConnectRelaysResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetUserConnectRelaysResponseImplToJson(
      this,
    );
  }
}

abstract class _SetUserConnectRelaysResponse
    implements SetUserConnectRelaysResponse {
  const factory _SetUserConnectRelaysResponse(
          {required final List<String> ionConnectRelays}) =
      _$SetUserConnectRelaysResponseImpl;

  factory _SetUserConnectRelaysResponse.fromJson(Map<String, dynamic> json) =
      _$SetUserConnectRelaysResponseImpl.fromJson;

  @override
  List<String> get ionConnectRelays;

  /// Create a copy of SetUserConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetUserConnectRelaysResponseImplCopyWith<
          _$SetUserConnectRelaysResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
