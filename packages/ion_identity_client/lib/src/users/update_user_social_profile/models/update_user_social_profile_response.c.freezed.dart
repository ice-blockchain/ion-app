// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_social_profile_response.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateUserSocialProfileResponse _$UpdateUserSocialProfileResponseFromJson(
    Map<String, dynamic> json) {
  return _UpdateUserSocialProfileResponse.fromJson(json);
}

/// @nodoc
mixin _$UpdateUserSocialProfileResponse {
  String get username => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get referral => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get usernameProof =>
      throw _privateConstructorUsedError;

  /// Serializes this UpdateUserSocialProfileResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateUserSocialProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateUserSocialProfileResponseCopyWith<UpdateUserSocialProfileResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateUserSocialProfileResponseCopyWith<$Res> {
  factory $UpdateUserSocialProfileResponseCopyWith(
          UpdateUserSocialProfileResponse value,
          $Res Function(UpdateUserSocialProfileResponse) then) =
      _$UpdateUserSocialProfileResponseCopyWithImpl<$Res,
          UpdateUserSocialProfileResponse>;
  @useResult
  $Res call(
      {String username,
      String? displayName,
      String? referral,
      List<Map<String, dynamic>> usernameProof});
}

/// @nodoc
class _$UpdateUserSocialProfileResponseCopyWithImpl<$Res,
        $Val extends UpdateUserSocialProfileResponse>
    implements $UpdateUserSocialProfileResponseCopyWith<$Res> {
  _$UpdateUserSocialProfileResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateUserSocialProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? displayName = freezed,
    Object? referral = freezed,
    Object? usernameProof = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      referral: freezed == referral
          ? _value.referral
          : referral // ignore: cast_nullable_to_non_nullable
              as String?,
      usernameProof: null == usernameProof
          ? _value.usernameProof
          : usernameProof // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateUserSocialProfileResponseImplCopyWith<$Res>
    implements $UpdateUserSocialProfileResponseCopyWith<$Res> {
  factory _$$UpdateUserSocialProfileResponseImplCopyWith(
          _$UpdateUserSocialProfileResponseImpl value,
          $Res Function(_$UpdateUserSocialProfileResponseImpl) then) =
      __$$UpdateUserSocialProfileResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String username,
      String? displayName,
      String? referral,
      List<Map<String, dynamic>> usernameProof});
}

/// @nodoc
class __$$UpdateUserSocialProfileResponseImplCopyWithImpl<$Res>
    extends _$UpdateUserSocialProfileResponseCopyWithImpl<$Res,
        _$UpdateUserSocialProfileResponseImpl>
    implements _$$UpdateUserSocialProfileResponseImplCopyWith<$Res> {
  __$$UpdateUserSocialProfileResponseImplCopyWithImpl(
      _$UpdateUserSocialProfileResponseImpl _value,
      $Res Function(_$UpdateUserSocialProfileResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateUserSocialProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? displayName = freezed,
    Object? referral = freezed,
    Object? usernameProof = null,
  }) {
    return _then(_$UpdateUserSocialProfileResponseImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      referral: freezed == referral
          ? _value.referral
          : referral // ignore: cast_nullable_to_non_nullable
              as String?,
      usernameProof: null == usernameProof
          ? _value._usernameProof
          : usernameProof // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateUserSocialProfileResponseImpl
    implements _UpdateUserSocialProfileResponse {
  const _$UpdateUserSocialProfileResponseImpl(
      {required this.username,
      required this.displayName,
      required this.referral,
      required final List<Map<String, dynamic>> usernameProof})
      : _usernameProof = usernameProof;

  factory _$UpdateUserSocialProfileResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateUserSocialProfileResponseImplFromJson(json);

  @override
  final String username;
  @override
  final String? displayName;
  @override
  final String? referral;
  final List<Map<String, dynamic>> _usernameProof;
  @override
  List<Map<String, dynamic>> get usernameProof {
    if (_usernameProof is EqualUnmodifiableListView) return _usernameProof;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_usernameProof);
  }

  @override
  String toString() {
    return 'UpdateUserSocialProfileResponse(username: $username, displayName: $displayName, referral: $referral, usernameProof: $usernameProof)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserSocialProfileResponseImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.referral, referral) ||
                other.referral == referral) &&
            const DeepCollectionEquality()
                .equals(other._usernameProof, _usernameProof));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, displayName, referral,
      const DeepCollectionEquality().hash(_usernameProof));

  /// Create a copy of UpdateUserSocialProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserSocialProfileResponseImplCopyWith<
          _$UpdateUserSocialProfileResponseImpl>
      get copyWith => __$$UpdateUserSocialProfileResponseImplCopyWithImpl<
          _$UpdateUserSocialProfileResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateUserSocialProfileResponseImplToJson(
      this,
    );
  }
}

abstract class _UpdateUserSocialProfileResponse
    implements UpdateUserSocialProfileResponse {
  const factory _UpdateUserSocialProfileResponse(
          {required final String username,
          required final String? displayName,
          required final String? referral,
          required final List<Map<String, dynamic>> usernameProof}) =
      _$UpdateUserSocialProfileResponseImpl;

  factory _UpdateUserSocialProfileResponse.fromJson(Map<String, dynamic> json) =
      _$UpdateUserSocialProfileResponseImpl.fromJson;

  @override
  String get username;
  @override
  String? get displayName;
  @override
  String? get referral;
  @override
  List<Map<String, dynamic>> get usernameProof;

  /// Create a copy of UpdateUserSocialProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateUserSocialProfileResponseImplCopyWith<
          _$UpdateUserSocialProfileResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
