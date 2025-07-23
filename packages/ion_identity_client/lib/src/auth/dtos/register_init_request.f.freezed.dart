// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_init_request.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegisterInitRequest _$RegisterInitRequestFromJson(Map<String, dynamic> json) {
  return _RegisterInitRequest.fromJson(json);
}

/// @nodoc
mixin _$RegisterInitRequest {
  String get email => throw _privateConstructorUsedError;
  String? get earlyAccessEmail => throw _privateConstructorUsedError;

  /// Serializes this RegisterInitRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterInitRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterInitRequestCopyWith<RegisterInitRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterInitRequestCopyWith<$Res> {
  factory $RegisterInitRequestCopyWith(
          RegisterInitRequest value, $Res Function(RegisterInitRequest) then) =
      _$RegisterInitRequestCopyWithImpl<$Res, RegisterInitRequest>;
  @useResult
  $Res call({String email, String? earlyAccessEmail});
}

/// @nodoc
class _$RegisterInitRequestCopyWithImpl<$Res, $Val extends RegisterInitRequest>
    implements $RegisterInitRequestCopyWith<$Res> {
  _$RegisterInitRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterInitRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? earlyAccessEmail = freezed,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      earlyAccessEmail: freezed == earlyAccessEmail
          ? _value.earlyAccessEmail
          : earlyAccessEmail // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterInitRequestImplCopyWith<$Res>
    implements $RegisterInitRequestCopyWith<$Res> {
  factory _$$RegisterInitRequestImplCopyWith(_$RegisterInitRequestImpl value,
          $Res Function(_$RegisterInitRequestImpl) then) =
      __$$RegisterInitRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String? earlyAccessEmail});
}

/// @nodoc
class __$$RegisterInitRequestImplCopyWithImpl<$Res>
    extends _$RegisterInitRequestCopyWithImpl<$Res, _$RegisterInitRequestImpl>
    implements _$$RegisterInitRequestImplCopyWith<$Res> {
  __$$RegisterInitRequestImplCopyWithImpl(_$RegisterInitRequestImpl _value,
      $Res Function(_$RegisterInitRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegisterInitRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? earlyAccessEmail = freezed,
  }) {
    return _then(_$RegisterInitRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      earlyAccessEmail: freezed == earlyAccessEmail
          ? _value.earlyAccessEmail
          : earlyAccessEmail // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterInitRequestImpl implements _RegisterInitRequest {
  const _$RegisterInitRequestImpl({required this.email, this.earlyAccessEmail});

  factory _$RegisterInitRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterInitRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String? earlyAccessEmail;

  @override
  String toString() {
    return 'RegisterInitRequest(email: $email, earlyAccessEmail: $earlyAccessEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterInitRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.earlyAccessEmail, earlyAccessEmail) ||
                other.earlyAccessEmail == earlyAccessEmail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, earlyAccessEmail);

  /// Create a copy of RegisterInitRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterInitRequestImplCopyWith<_$RegisterInitRequestImpl> get copyWith =>
      __$$RegisterInitRequestImplCopyWithImpl<_$RegisterInitRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterInitRequestImplToJson(
      this,
    );
  }
}

abstract class _RegisterInitRequest implements RegisterInitRequest {
  const factory _RegisterInitRequest(
      {required final String email,
      final String? earlyAccessEmail}) = _$RegisterInitRequestImpl;

  factory _RegisterInitRequest.fromJson(Map<String, dynamic> json) =
      _$RegisterInitRequestImpl.fromJson;

  @override
  String get email;
  @override
  String? get earlyAccessEmail;

  /// Create a copy of RegisterInitRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterInitRequestImplCopyWith<_$RegisterInitRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
