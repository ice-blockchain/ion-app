// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_key_request.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateKeyRequest _$UpdateKeyRequestFromJson(Map<String, dynamic> json) {
  return _UpdateKeyRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateKeyRequest {
  String get name => throw _privateConstructorUsedError;

  /// Serializes this UpdateKeyRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateKeyRequestCopyWith<UpdateKeyRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateKeyRequestCopyWith<$Res> {
  factory $UpdateKeyRequestCopyWith(
          UpdateKeyRequest value, $Res Function(UpdateKeyRequest) then) =
      _$UpdateKeyRequestCopyWithImpl<$Res, UpdateKeyRequest>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$UpdateKeyRequestCopyWithImpl<$Res, $Val extends UpdateKeyRequest>
    implements $UpdateKeyRequestCopyWith<$Res> {
  _$UpdateKeyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateKeyRequestImplCopyWith<$Res>
    implements $UpdateKeyRequestCopyWith<$Res> {
  factory _$$UpdateKeyRequestImplCopyWith(_$UpdateKeyRequestImpl value,
          $Res Function(_$UpdateKeyRequestImpl) then) =
      __$$UpdateKeyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$UpdateKeyRequestImplCopyWithImpl<$Res>
    extends _$UpdateKeyRequestCopyWithImpl<$Res, _$UpdateKeyRequestImpl>
    implements _$$UpdateKeyRequestImplCopyWith<$Res> {
  __$$UpdateKeyRequestImplCopyWithImpl(_$UpdateKeyRequestImpl _value,
      $Res Function(_$UpdateKeyRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$UpdateKeyRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateKeyRequestImpl implements _UpdateKeyRequest {
  _$UpdateKeyRequestImpl({required this.name});

  factory _$UpdateKeyRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateKeyRequestImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'UpdateKeyRequest(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateKeyRequestImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of UpdateKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateKeyRequestImplCopyWith<_$UpdateKeyRequestImpl> get copyWith =>
      __$$UpdateKeyRequestImplCopyWithImpl<_$UpdateKeyRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateKeyRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateKeyRequest implements UpdateKeyRequest {
  factory _UpdateKeyRequest({required final String name}) =
      _$UpdateKeyRequestImpl;

  factory _UpdateKeyRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateKeyRequestImpl.fromJson;

  @override
  String get name;

  /// Create a copy of UpdateKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateKeyRequestImplCopyWith<_$UpdateKeyRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
