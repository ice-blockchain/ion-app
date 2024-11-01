// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_ion_connect_relays_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SetIonConnectRelaysResponse _$SetIonConnectRelaysResponseFromJson(
    Map<String, dynamic> json) {
  return _SetIonConnectRelaysResponse.fromJson(json);
}

/// @nodoc
mixin _$SetIonConnectRelaysResponse {
  List<String> get ionConnectRelays => throw _privateConstructorUsedError;

  /// Serializes this SetIonConnectRelaysResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SetIonConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetIonConnectRelaysResponseCopyWith<SetIonConnectRelaysResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetIonConnectRelaysResponseCopyWith<$Res> {
  factory $SetIonConnectRelaysResponseCopyWith(
          SetIonConnectRelaysResponse value,
          $Res Function(SetIonConnectRelaysResponse) then) =
      _$SetIonConnectRelaysResponseCopyWithImpl<$Res,
          SetIonConnectRelaysResponse>;
  @useResult
  $Res call({List<String> ionConnectRelays});
}

/// @nodoc
class _$SetIonConnectRelaysResponseCopyWithImpl<$Res,
        $Val extends SetIonConnectRelaysResponse>
    implements $SetIonConnectRelaysResponseCopyWith<$Res> {
  _$SetIonConnectRelaysResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetIonConnectRelaysResponse
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
abstract class _$$SetIonConnectRelaysResponseImplCopyWith<$Res>
    implements $SetIonConnectRelaysResponseCopyWith<$Res> {
  factory _$$SetIonConnectRelaysResponseImplCopyWith(
          _$SetIonConnectRelaysResponseImpl value,
          $Res Function(_$SetIonConnectRelaysResponseImpl) then) =
      __$$SetIonConnectRelaysResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> ionConnectRelays});
}

/// @nodoc
class __$$SetIonConnectRelaysResponseImplCopyWithImpl<$Res>
    extends _$SetIonConnectRelaysResponseCopyWithImpl<$Res,
        _$SetIonConnectRelaysResponseImpl>
    implements _$$SetIonConnectRelaysResponseImplCopyWith<$Res> {
  __$$SetIonConnectRelaysResponseImplCopyWithImpl(
      _$SetIonConnectRelaysResponseImpl _value,
      $Res Function(_$SetIonConnectRelaysResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SetIonConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ionConnectRelays = null,
  }) {
    return _then(_$SetIonConnectRelaysResponseImpl(
      ionConnectRelays: null == ionConnectRelays
          ? _value._ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetIonConnectRelaysResponseImpl
    implements _SetIonConnectRelaysResponse {
  const _$SetIonConnectRelaysResponseImpl(
      {required final List<String> ionConnectRelays})
      : _ionConnectRelays = ionConnectRelays;

  factory _$SetIonConnectRelaysResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SetIonConnectRelaysResponseImplFromJson(json);

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
    return 'SetIonConnectRelaysResponse(ionConnectRelays: $ionConnectRelays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetIonConnectRelaysResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._ionConnectRelays, _ionConnectRelays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_ionConnectRelays));

  /// Create a copy of SetIonConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetIonConnectRelaysResponseImplCopyWith<_$SetIonConnectRelaysResponseImpl>
      get copyWith => __$$SetIonConnectRelaysResponseImplCopyWithImpl<
          _$SetIonConnectRelaysResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetIonConnectRelaysResponseImplToJson(
      this,
    );
  }
}

abstract class _SetIonConnectRelaysResponse
    implements SetIonConnectRelaysResponse {
  const factory _SetIonConnectRelaysResponse(
          {required final List<String> ionConnectRelays}) =
      _$SetIonConnectRelaysResponseImpl;

  factory _SetIonConnectRelaysResponse.fromJson(Map<String, dynamic> json) =
      _$SetIonConnectRelaysResponseImpl.fromJson;

  @override
  List<String> get ionConnectRelays;

  /// Create a copy of SetIonConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetIonConnectRelaysResponseImplCopyWith<_$SetIonConnectRelaysResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
