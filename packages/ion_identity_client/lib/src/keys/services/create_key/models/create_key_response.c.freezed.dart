// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_key_response.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateKeyResponse _$CreateKeyResponseFromJson(Map<String, dynamic> json) {
  return _CreateKeyResponse.fromJson(json);
}

/// @nodoc
mixin _$CreateKeyResponse {
  String get id => throw _privateConstructorUsedError;
  String get scheme => throw _privateConstructorUsedError;
  String get curve => throw _privateConstructorUsedError;
  String get publicKey => throw _privateConstructorUsedError;
  KeyStatus get status => throw _privateConstructorUsedError;
  bool get custodial => throw _privateConstructorUsedError;
  DateTime get dateCreated => throw _privateConstructorUsedError;

  /// Serializes this CreateKeyResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateKeyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateKeyResponseCopyWith<CreateKeyResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateKeyResponseCopyWith<$Res> {
  factory $CreateKeyResponseCopyWith(
          CreateKeyResponse value, $Res Function(CreateKeyResponse) then) =
      _$CreateKeyResponseCopyWithImpl<$Res, CreateKeyResponse>;
  @useResult
  $Res call(
      {String id,
      String scheme,
      String curve,
      String publicKey,
      KeyStatus status,
      bool custodial,
      DateTime dateCreated});
}

/// @nodoc
class _$CreateKeyResponseCopyWithImpl<$Res, $Val extends CreateKeyResponse>
    implements $CreateKeyResponseCopyWith<$Res> {
  _$CreateKeyResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateKeyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? scheme = null,
    Object? curve = null,
    Object? publicKey = null,
    Object? status = null,
    Object? custodial = null,
    Object? dateCreated = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      scheme: null == scheme
          ? _value.scheme
          : scheme // ignore: cast_nullable_to_non_nullable
              as String,
      curve: null == curve
          ? _value.curve
          : curve // ignore: cast_nullable_to_non_nullable
              as String,
      publicKey: null == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as KeyStatus,
      custodial: null == custodial
          ? _value.custodial
          : custodial // ignore: cast_nullable_to_non_nullable
              as bool,
      dateCreated: null == dateCreated
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateKeyResponseImplCopyWith<$Res>
    implements $CreateKeyResponseCopyWith<$Res> {
  factory _$$CreateKeyResponseImplCopyWith(_$CreateKeyResponseImpl value,
          $Res Function(_$CreateKeyResponseImpl) then) =
      __$$CreateKeyResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String scheme,
      String curve,
      String publicKey,
      KeyStatus status,
      bool custodial,
      DateTime dateCreated});
}

/// @nodoc
class __$$CreateKeyResponseImplCopyWithImpl<$Res>
    extends _$CreateKeyResponseCopyWithImpl<$Res, _$CreateKeyResponseImpl>
    implements _$$CreateKeyResponseImplCopyWith<$Res> {
  __$$CreateKeyResponseImplCopyWithImpl(_$CreateKeyResponseImpl _value,
      $Res Function(_$CreateKeyResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateKeyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? scheme = null,
    Object? curve = null,
    Object? publicKey = null,
    Object? status = null,
    Object? custodial = null,
    Object? dateCreated = null,
  }) {
    return _then(_$CreateKeyResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      scheme: null == scheme
          ? _value.scheme
          : scheme // ignore: cast_nullable_to_non_nullable
              as String,
      curve: null == curve
          ? _value.curve
          : curve // ignore: cast_nullable_to_non_nullable
              as String,
      publicKey: null == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as KeyStatus,
      custodial: null == custodial
          ? _value.custodial
          : custodial // ignore: cast_nullable_to_non_nullable
              as bool,
      dateCreated: null == dateCreated
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateKeyResponseImpl implements _CreateKeyResponse {
  _$CreateKeyResponseImpl(
      {required this.id,
      required this.scheme,
      required this.curve,
      required this.publicKey,
      required this.status,
      required this.custodial,
      required this.dateCreated});

  factory _$CreateKeyResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateKeyResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String scheme;
  @override
  final String curve;
  @override
  final String publicKey;
  @override
  final KeyStatus status;
  @override
  final bool custodial;
  @override
  final DateTime dateCreated;

  @override
  String toString() {
    return 'CreateKeyResponse(id: $id, scheme: $scheme, curve: $curve, publicKey: $publicKey, status: $status, custodial: $custodial, dateCreated: $dateCreated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateKeyResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.scheme, scheme) || other.scheme == scheme) &&
            (identical(other.curve, curve) || other.curve == curve) &&
            (identical(other.publicKey, publicKey) ||
                other.publicKey == publicKey) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.custodial, custodial) ||
                other.custodial == custodial) &&
            (identical(other.dateCreated, dateCreated) ||
                other.dateCreated == dateCreated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, scheme, curve, publicKey,
      status, custodial, dateCreated);

  /// Create a copy of CreateKeyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateKeyResponseImplCopyWith<_$CreateKeyResponseImpl> get copyWith =>
      __$$CreateKeyResponseImplCopyWithImpl<_$CreateKeyResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateKeyResponseImplToJson(
      this,
    );
  }
}

abstract class _CreateKeyResponse implements CreateKeyResponse {
  factory _CreateKeyResponse(
      {required final String id,
      required final String scheme,
      required final String curve,
      required final String publicKey,
      required final KeyStatus status,
      required final bool custodial,
      required final DateTime dateCreated}) = _$CreateKeyResponseImpl;

  factory _CreateKeyResponse.fromJson(Map<String, dynamic> json) =
      _$CreateKeyResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get scheme;
  @override
  String get curve;
  @override
  String get publicKey;
  @override
  KeyStatus get status;
  @override
  bool get custodial;
  @override
  DateTime get dateCreated;

  /// Create a copy of CreateKeyResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateKeyResponseImplCopyWith<_$CreateKeyResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
