// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'available_ion_connect_relays_response.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AvailableIONConnectRelaysResponse _$AvailableIONConnectRelaysResponseFromJson(
    Map<String, dynamic> json) {
  return _AvailableIONConnectRelaysResponse.fromJson(json);
}

/// @nodoc
mixin _$AvailableIONConnectRelaysResponse {
  List<IonConnectRelayInfo> get ionConnectRelays =>
      throw _privateConstructorUsedError;

  /// Serializes this AvailableIONConnectRelaysResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailableIONConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailableIONConnectRelaysResponseCopyWith<AvailableIONConnectRelaysResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableIONConnectRelaysResponseCopyWith<$Res> {
  factory $AvailableIONConnectRelaysResponseCopyWith(
          AvailableIONConnectRelaysResponse value,
          $Res Function(AvailableIONConnectRelaysResponse) then) =
      _$AvailableIONConnectRelaysResponseCopyWithImpl<$Res,
          AvailableIONConnectRelaysResponse>;
  @useResult
  $Res call({List<IonConnectRelayInfo> ionConnectRelays});
}

/// @nodoc
class _$AvailableIONConnectRelaysResponseCopyWithImpl<$Res,
        $Val extends AvailableIONConnectRelaysResponse>
    implements $AvailableIONConnectRelaysResponseCopyWith<$Res> {
  _$AvailableIONConnectRelaysResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailableIONConnectRelaysResponse
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
              as List<IonConnectRelayInfo>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailableIONConnectRelaysResponseImplCopyWith<$Res>
    implements $AvailableIONConnectRelaysResponseCopyWith<$Res> {
  factory _$$AvailableIONConnectRelaysResponseImplCopyWith(
          _$AvailableIONConnectRelaysResponseImpl value,
          $Res Function(_$AvailableIONConnectRelaysResponseImpl) then) =
      __$$AvailableIONConnectRelaysResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<IonConnectRelayInfo> ionConnectRelays});
}

/// @nodoc
class __$$AvailableIONConnectRelaysResponseImplCopyWithImpl<$Res>
    extends _$AvailableIONConnectRelaysResponseCopyWithImpl<$Res,
        _$AvailableIONConnectRelaysResponseImpl>
    implements _$$AvailableIONConnectRelaysResponseImplCopyWith<$Res> {
  __$$AvailableIONConnectRelaysResponseImplCopyWithImpl(
      _$AvailableIONConnectRelaysResponseImpl _value,
      $Res Function(_$AvailableIONConnectRelaysResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AvailableIONConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ionConnectRelays = null,
  }) {
    return _then(_$AvailableIONConnectRelaysResponseImpl(
      ionConnectRelays: null == ionConnectRelays
          ? _value._ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<IonConnectRelayInfo>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableIONConnectRelaysResponseImpl
    implements _AvailableIONConnectRelaysResponse {
  const _$AvailableIONConnectRelaysResponseImpl(
      {required final List<IonConnectRelayInfo> ionConnectRelays})
      : _ionConnectRelays = ionConnectRelays;

  factory _$AvailableIONConnectRelaysResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$AvailableIONConnectRelaysResponseImplFromJson(json);

  final List<IonConnectRelayInfo> _ionConnectRelays;
  @override
  List<IonConnectRelayInfo> get ionConnectRelays {
    if (_ionConnectRelays is EqualUnmodifiableListView)
      return _ionConnectRelays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ionConnectRelays);
  }

  @override
  String toString() {
    return 'AvailableIONConnectRelaysResponse(ionConnectRelays: $ionConnectRelays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableIONConnectRelaysResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._ionConnectRelays, _ionConnectRelays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_ionConnectRelays));

  /// Create a copy of AvailableIONConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableIONConnectRelaysResponseImplCopyWith<
          _$AvailableIONConnectRelaysResponseImpl>
      get copyWith => __$$AvailableIONConnectRelaysResponseImplCopyWithImpl<
          _$AvailableIONConnectRelaysResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableIONConnectRelaysResponseImplToJson(
      this,
    );
  }
}

abstract class _AvailableIONConnectRelaysResponse
    implements AvailableIONConnectRelaysResponse {
  const factory _AvailableIONConnectRelaysResponse(
          {required final List<IonConnectRelayInfo> ionConnectRelays}) =
      _$AvailableIONConnectRelaysResponseImpl;

  factory _AvailableIONConnectRelaysResponse.fromJson(
          Map<String, dynamic> json) =
      _$AvailableIONConnectRelaysResponseImpl.fromJson;

  @override
  List<IonConnectRelayInfo> get ionConnectRelays;

  /// Create a copy of AvailableIONConnectRelaysResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailableIONConnectRelaysResponseImplCopyWith<
          _$AvailableIONConnectRelaysResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
