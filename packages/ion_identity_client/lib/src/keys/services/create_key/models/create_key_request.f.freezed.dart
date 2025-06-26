// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_key_request.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateKeyRequest _$CreateKeyRequestFromJson(Map<String, dynamic> json) {
  return _CreateKeyRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateKeyRequest {
  String get scheme => throw _privateConstructorUsedError;
  String get curve => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this CreateKeyRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateKeyRequestCopyWith<CreateKeyRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateKeyRequestCopyWith<$Res> {
  factory $CreateKeyRequestCopyWith(
          CreateKeyRequest value, $Res Function(CreateKeyRequest) then) =
      _$CreateKeyRequestCopyWithImpl<$Res, CreateKeyRequest>;
  @useResult
  $Res call(
      {String scheme,
      String curve,
      @JsonKey(includeIfNull: false) String? name});
}

/// @nodoc
class _$CreateKeyRequestCopyWithImpl<$Res, $Val extends CreateKeyRequest>
    implements $CreateKeyRequestCopyWith<$Res> {
  _$CreateKeyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheme = null,
    Object? curve = null,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      scheme: null == scheme
          ? _value.scheme
          : scheme // ignore: cast_nullable_to_non_nullable
              as String,
      curve: null == curve
          ? _value.curve
          : curve // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateKeyRequestImplCopyWith<$Res>
    implements $CreateKeyRequestCopyWith<$Res> {
  factory _$$CreateKeyRequestImplCopyWith(_$CreateKeyRequestImpl value,
          $Res Function(_$CreateKeyRequestImpl) then) =
      __$$CreateKeyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String scheme,
      String curve,
      @JsonKey(includeIfNull: false) String? name});
}

/// @nodoc
class __$$CreateKeyRequestImplCopyWithImpl<$Res>
    extends _$CreateKeyRequestCopyWithImpl<$Res, _$CreateKeyRequestImpl>
    implements _$$CreateKeyRequestImplCopyWith<$Res> {
  __$$CreateKeyRequestImplCopyWithImpl(_$CreateKeyRequestImpl _value,
      $Res Function(_$CreateKeyRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheme = null,
    Object? curve = null,
    Object? name = freezed,
  }) {
    return _then(_$CreateKeyRequestImpl(
      scheme: null == scheme
          ? _value.scheme
          : scheme // ignore: cast_nullable_to_non_nullable
              as String,
      curve: null == curve
          ? _value.curve
          : curve // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateKeyRequestImpl implements _CreateKeyRequest {
  _$CreateKeyRequestImpl(
      {required this.scheme,
      required this.curve,
      @JsonKey(includeIfNull: false) this.name});

  factory _$CreateKeyRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateKeyRequestImplFromJson(json);

  @override
  final String scheme;
  @override
  final String curve;
  @override
  @JsonKey(includeIfNull: false)
  final String? name;

  @override
  String toString() {
    return 'CreateKeyRequest(scheme: $scheme, curve: $curve, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateKeyRequestImpl &&
            (identical(other.scheme, scheme) || other.scheme == scheme) &&
            (identical(other.curve, curve) || other.curve == curve) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, scheme, curve, name);

  /// Create a copy of CreateKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateKeyRequestImplCopyWith<_$CreateKeyRequestImpl> get copyWith =>
      __$$CreateKeyRequestImplCopyWithImpl<_$CreateKeyRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateKeyRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateKeyRequest implements CreateKeyRequest {
  factory _CreateKeyRequest(
          {required final String scheme,
          required final String curve,
          @JsonKey(includeIfNull: false) final String? name}) =
      _$CreateKeyRequestImpl;

  factory _CreateKeyRequest.fromJson(Map<String, dynamic> json) =
      _$CreateKeyRequestImpl.fromJson;

  @override
  String get scheme;
  @override
  String get curve;
  @override
  @JsonKey(includeIfNull: false)
  String? get name;

  /// Create a copy of CreateKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateKeyRequestImplCopyWith<_$CreateKeyRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
