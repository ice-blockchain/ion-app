// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_token.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserToken _$UserTokenFromJson(Map<String, dynamic> json) {
  return _UserToken.fromJson(json);
}

/// @nodoc
mixin _$UserToken {
  String get username => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this UserToken to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserTokenCopyWith<UserToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserTokenCopyWith<$Res> {
  factory $UserTokenCopyWith(UserToken value, $Res Function(UserToken) then) =
      _$UserTokenCopyWithImpl<$Res, UserToken>;
  @useResult
  $Res call({String username, String token, String refreshToken});
}

/// @nodoc
class _$UserTokenCopyWithImpl<$Res, $Val extends UserToken>
    implements $UserTokenCopyWith<$Res> {
  _$UserTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? token = null,
    Object? refreshToken = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserTokenImplCopyWith<$Res>
    implements $UserTokenCopyWith<$Res> {
  factory _$$UserTokenImplCopyWith(
          _$UserTokenImpl value, $Res Function(_$UserTokenImpl) then) =
      __$$UserTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String token, String refreshToken});
}

/// @nodoc
class __$$UserTokenImplCopyWithImpl<$Res>
    extends _$UserTokenCopyWithImpl<$Res, _$UserTokenImpl>
    implements _$$UserTokenImplCopyWith<$Res> {
  __$$UserTokenImplCopyWithImpl(
      _$UserTokenImpl _value, $Res Function(_$UserTokenImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? token = null,
    Object? refreshToken = null,
  }) {
    return _then(_$UserTokenImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserTokenImpl extends _UserToken {
  const _$UserTokenImpl(
      {required this.username, required this.token, required this.refreshToken})
      : super._();

  factory _$UserTokenImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserTokenImplFromJson(json);

  @override
  final String username;
  @override
  final String token;
  @override
  final String refreshToken;

  @override
  String toString() {
    return 'UserToken(username: $username, token: $token, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserTokenImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, token, refreshToken);

  /// Create a copy of UserToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserTokenImplCopyWith<_$UserTokenImpl> get copyWith =>
      __$$UserTokenImplCopyWithImpl<_$UserTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserTokenImplToJson(
      this,
    );
  }
}

abstract class _UserToken extends UserToken {
  const factory _UserToken(
      {required final String username,
      required final String token,
      required final String refreshToken}) = _$UserTokenImpl;
  const _UserToken._() : super._();

  factory _UserToken.fromJson(Map<String, dynamic> json) =
      _$UserTokenImpl.fromJson;

  @override
  String get username;
  @override
  String get token;
  @override
  String get refreshToken;

  /// Create a copy of UserToken
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserTokenImplCopyWith<_$UserTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
