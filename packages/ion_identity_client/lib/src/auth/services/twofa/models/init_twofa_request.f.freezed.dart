// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'init_twofa_request.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InitTwoFARequest _$InitTwoFARequestFromJson(Map<String, dynamic> json) {
  return _InitTwoFARequest.fromJson(json);
}

/// @nodoc
mixin _$InitTwoFARequest {
  @JsonKey(includeIfNull: false, name: '2FAVerificationCodes')
  Map<String, String>? get verificationCodes =>
      throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get replace => throw _privateConstructorUsedError;

  /// Serializes this InitTwoFARequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InitTwoFARequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InitTwoFARequestCopyWith<InitTwoFARequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InitTwoFARequestCopyWith<$Res> {
  factory $InitTwoFARequestCopyWith(
          InitTwoFARequest value, $Res Function(InitTwoFARequest) then) =
      _$InitTwoFARequestCopyWithImpl<$Res, InitTwoFARequest>;
  @useResult
  $Res call(
      {@JsonKey(includeIfNull: false, name: '2FAVerificationCodes')
      Map<String, String>? verificationCodes,
      @JsonKey(includeIfNull: false) String? email,
      @JsonKey(includeIfNull: false) String? phoneNumber,
      @JsonKey(includeIfNull: false) String? replace});
}

/// @nodoc
class _$InitTwoFARequestCopyWithImpl<$Res, $Val extends InitTwoFARequest>
    implements $InitTwoFARequestCopyWith<$Res> {
  _$InitTwoFARequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InitTwoFARequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verificationCodes = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? replace = freezed,
  }) {
    return _then(_value.copyWith(
      verificationCodes: freezed == verificationCodes
          ? _value.verificationCodes
          : verificationCodes // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      replace: freezed == replace
          ? _value.replace
          : replace // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InitTwoFARequestImplCopyWith<$Res>
    implements $InitTwoFARequestCopyWith<$Res> {
  factory _$$InitTwoFARequestImplCopyWith(_$InitTwoFARequestImpl value,
          $Res Function(_$InitTwoFARequestImpl) then) =
      __$$InitTwoFARequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(includeIfNull: false, name: '2FAVerificationCodes')
      Map<String, String>? verificationCodes,
      @JsonKey(includeIfNull: false) String? email,
      @JsonKey(includeIfNull: false) String? phoneNumber,
      @JsonKey(includeIfNull: false) String? replace});
}

/// @nodoc
class __$$InitTwoFARequestImplCopyWithImpl<$Res>
    extends _$InitTwoFARequestCopyWithImpl<$Res, _$InitTwoFARequestImpl>
    implements _$$InitTwoFARequestImplCopyWith<$Res> {
  __$$InitTwoFARequestImplCopyWithImpl(_$InitTwoFARequestImpl _value,
      $Res Function(_$InitTwoFARequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of InitTwoFARequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verificationCodes = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? replace = freezed,
  }) {
    return _then(_$InitTwoFARequestImpl(
      verificationCodes: freezed == verificationCodes
          ? _value._verificationCodes
          : verificationCodes // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      replace: freezed == replace
          ? _value.replace
          : replace // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InitTwoFARequestImpl implements _InitTwoFARequest {
  _$InitTwoFARequestImpl(
      {@JsonKey(includeIfNull: false, name: '2FAVerificationCodes')
      final Map<String, String>? verificationCodes,
      @JsonKey(includeIfNull: false) this.email,
      @JsonKey(includeIfNull: false) this.phoneNumber,
      @JsonKey(includeIfNull: false) this.replace})
      : _verificationCodes = verificationCodes;

  factory _$InitTwoFARequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$InitTwoFARequestImplFromJson(json);

  final Map<String, String>? _verificationCodes;
  @override
  @JsonKey(includeIfNull: false, name: '2FAVerificationCodes')
  Map<String, String>? get verificationCodes {
    final value = _verificationCodes;
    if (value == null) return null;
    if (_verificationCodes is EqualUnmodifiableMapView)
      return _verificationCodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(includeIfNull: false)
  final String? email;
  @override
  @JsonKey(includeIfNull: false)
  final String? phoneNumber;
  @override
  @JsonKey(includeIfNull: false)
  final String? replace;

  @override
  String toString() {
    return 'InitTwoFARequest(verificationCodes: $verificationCodes, email: $email, phoneNumber: $phoneNumber, replace: $replace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitTwoFARequestImpl &&
            const DeepCollectionEquality()
                .equals(other._verificationCodes, _verificationCodes) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.replace, replace) || other.replace == replace));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_verificationCodes),
      email,
      phoneNumber,
      replace);

  /// Create a copy of InitTwoFARequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitTwoFARequestImplCopyWith<_$InitTwoFARequestImpl> get copyWith =>
      __$$InitTwoFARequestImplCopyWithImpl<_$InitTwoFARequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InitTwoFARequestImplToJson(
      this,
    );
  }
}

abstract class _InitTwoFARequest implements InitTwoFARequest {
  factory _InitTwoFARequest(
          {@JsonKey(includeIfNull: false, name: '2FAVerificationCodes')
          final Map<String, String>? verificationCodes,
          @JsonKey(includeIfNull: false) final String? email,
          @JsonKey(includeIfNull: false) final String? phoneNumber,
          @JsonKey(includeIfNull: false) final String? replace}) =
      _$InitTwoFARequestImpl;

  factory _InitTwoFARequest.fromJson(Map<String, dynamic> json) =
      _$InitTwoFARequestImpl.fromJson;

  @override
  @JsonKey(includeIfNull: false, name: '2FAVerificationCodes')
  Map<String, String>? get verificationCodes;
  @override
  @JsonKey(includeIfNull: false)
  String? get email;
  @override
  @JsonKey(includeIfNull: false)
  String? get phoneNumber;
  @override
  @JsonKey(includeIfNull: false)
  String? get replace;

  /// Create a copy of InitTwoFARequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitTwoFARequestImplCopyWith<_$InitTwoFARequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
