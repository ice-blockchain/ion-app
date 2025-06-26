// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delegated_login_request.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DelegatedLoginRequest _$DelegatedLoginRequestFromJson(
    Map<String, dynamic> json) {
  return _DelegatedLoginRequest.fromJson(json);
}

/// @nodoc
mixin _$DelegatedLoginRequest {
  String get username => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this DelegatedLoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DelegatedLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DelegatedLoginRequestCopyWith<DelegatedLoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DelegatedLoginRequestCopyWith<$Res> {
  factory $DelegatedLoginRequestCopyWith(DelegatedLoginRequest value,
          $Res Function(DelegatedLoginRequest) then) =
      _$DelegatedLoginRequestCopyWithImpl<$Res, DelegatedLoginRequest>;
  @useResult
  $Res call({String username, String refreshToken});
}

/// @nodoc
class _$DelegatedLoginRequestCopyWithImpl<$Res,
        $Val extends DelegatedLoginRequest>
    implements $DelegatedLoginRequestCopyWith<$Res> {
  _$DelegatedLoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DelegatedLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? refreshToken = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DelegatedLoginRequestImplCopyWith<$Res>
    implements $DelegatedLoginRequestCopyWith<$Res> {
  factory _$$DelegatedLoginRequestImplCopyWith(
          _$DelegatedLoginRequestImpl value,
          $Res Function(_$DelegatedLoginRequestImpl) then) =
      __$$DelegatedLoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String refreshToken});
}

/// @nodoc
class __$$DelegatedLoginRequestImplCopyWithImpl<$Res>
    extends _$DelegatedLoginRequestCopyWithImpl<$Res,
        _$DelegatedLoginRequestImpl>
    implements _$$DelegatedLoginRequestImplCopyWith<$Res> {
  __$$DelegatedLoginRequestImplCopyWithImpl(_$DelegatedLoginRequestImpl _value,
      $Res Function(_$DelegatedLoginRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of DelegatedLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? refreshToken = null,
  }) {
    return _then(_$DelegatedLoginRequestImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
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
class _$DelegatedLoginRequestImpl implements _DelegatedLoginRequest {
  const _$DelegatedLoginRequestImpl(
      {required this.username, required this.refreshToken});

  factory _$DelegatedLoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$DelegatedLoginRequestImplFromJson(json);

  @override
  final String username;
  @override
  final String refreshToken;

  @override
  String toString() {
    return 'DelegatedLoginRequest(username: $username, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DelegatedLoginRequestImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, refreshToken);

  /// Create a copy of DelegatedLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DelegatedLoginRequestImplCopyWith<_$DelegatedLoginRequestImpl>
      get copyWith => __$$DelegatedLoginRequestImplCopyWithImpl<
          _$DelegatedLoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DelegatedLoginRequestImplToJson(
      this,
    );
  }
}

abstract class _DelegatedLoginRequest implements DelegatedLoginRequest {
  const factory _DelegatedLoginRequest(
      {required final String username,
      required final String refreshToken}) = _$DelegatedLoginRequestImpl;

  factory _DelegatedLoginRequest.fromJson(Map<String, dynamic> json) =
      _$DelegatedLoginRequestImpl.fromJson;

  @override
  String get username;
  @override
  String get refreshToken;

  /// Create a copy of DelegatedLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DelegatedLoginRequestImplCopyWith<_$DelegatedLoginRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
