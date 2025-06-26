// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_action_signing_init_request.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserActionSigningInitRequest _$UserActionSigningInitRequestFromJson(
    Map<String, dynamic> json) {
  return _UserActionSigningInitRequest.fromJson(json);
}

/// @nodoc
mixin _$UserActionSigningInitRequest {
  String get userActionPayload => throw _privateConstructorUsedError;
  String get userActionHttpMethod => throw _privateConstructorUsedError;
  String get userActionHttpPath => throw _privateConstructorUsedError;
  String get userActionServerKind => throw _privateConstructorUsedError;

  /// Serializes this UserActionSigningInitRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserActionSigningInitRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserActionSigningInitRequestCopyWith<UserActionSigningInitRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserActionSigningInitRequestCopyWith<$Res> {
  factory $UserActionSigningInitRequestCopyWith(
          UserActionSigningInitRequest value,
          $Res Function(UserActionSigningInitRequest) then) =
      _$UserActionSigningInitRequestCopyWithImpl<$Res,
          UserActionSigningInitRequest>;
  @useResult
  $Res call(
      {String userActionPayload,
      String userActionHttpMethod,
      String userActionHttpPath,
      String userActionServerKind});
}

/// @nodoc
class _$UserActionSigningInitRequestCopyWithImpl<$Res,
        $Val extends UserActionSigningInitRequest>
    implements $UserActionSigningInitRequestCopyWith<$Res> {
  _$UserActionSigningInitRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserActionSigningInitRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userActionPayload = null,
    Object? userActionHttpMethod = null,
    Object? userActionHttpPath = null,
    Object? userActionServerKind = null,
  }) {
    return _then(_value.copyWith(
      userActionPayload: null == userActionPayload
          ? _value.userActionPayload
          : userActionPayload // ignore: cast_nullable_to_non_nullable
              as String,
      userActionHttpMethod: null == userActionHttpMethod
          ? _value.userActionHttpMethod
          : userActionHttpMethod // ignore: cast_nullable_to_non_nullable
              as String,
      userActionHttpPath: null == userActionHttpPath
          ? _value.userActionHttpPath
          : userActionHttpPath // ignore: cast_nullable_to_non_nullable
              as String,
      userActionServerKind: null == userActionServerKind
          ? _value.userActionServerKind
          : userActionServerKind // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserActionSigningInitRequestImplCopyWith<$Res>
    implements $UserActionSigningInitRequestCopyWith<$Res> {
  factory _$$UserActionSigningInitRequestImplCopyWith(
          _$UserActionSigningInitRequestImpl value,
          $Res Function(_$UserActionSigningInitRequestImpl) then) =
      __$$UserActionSigningInitRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userActionPayload,
      String userActionHttpMethod,
      String userActionHttpPath,
      String userActionServerKind});
}

/// @nodoc
class __$$UserActionSigningInitRequestImplCopyWithImpl<$Res>
    extends _$UserActionSigningInitRequestCopyWithImpl<$Res,
        _$UserActionSigningInitRequestImpl>
    implements _$$UserActionSigningInitRequestImplCopyWith<$Res> {
  __$$UserActionSigningInitRequestImplCopyWithImpl(
      _$UserActionSigningInitRequestImpl _value,
      $Res Function(_$UserActionSigningInitRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserActionSigningInitRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userActionPayload = null,
    Object? userActionHttpMethod = null,
    Object? userActionHttpPath = null,
    Object? userActionServerKind = null,
  }) {
    return _then(_$UserActionSigningInitRequestImpl(
      userActionPayload: null == userActionPayload
          ? _value.userActionPayload
          : userActionPayload // ignore: cast_nullable_to_non_nullable
              as String,
      userActionHttpMethod: null == userActionHttpMethod
          ? _value.userActionHttpMethod
          : userActionHttpMethod // ignore: cast_nullable_to_non_nullable
              as String,
      userActionHttpPath: null == userActionHttpPath
          ? _value.userActionHttpPath
          : userActionHttpPath // ignore: cast_nullable_to_non_nullable
              as String,
      userActionServerKind: null == userActionServerKind
          ? _value.userActionServerKind
          : userActionServerKind // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserActionSigningInitRequestImpl
    implements _UserActionSigningInitRequest {
  const _$UserActionSigningInitRequestImpl(
      {required this.userActionPayload,
      required this.userActionHttpMethod,
      required this.userActionHttpPath,
      this.userActionServerKind = 'Api'});

  factory _$UserActionSigningInitRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UserActionSigningInitRequestImplFromJson(json);

  @override
  final String userActionPayload;
  @override
  final String userActionHttpMethod;
  @override
  final String userActionHttpPath;
  @override
  @JsonKey()
  final String userActionServerKind;

  @override
  String toString() {
    return 'UserActionSigningInitRequest(userActionPayload: $userActionPayload, userActionHttpMethod: $userActionHttpMethod, userActionHttpPath: $userActionHttpPath, userActionServerKind: $userActionServerKind)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserActionSigningInitRequestImpl &&
            (identical(other.userActionPayload, userActionPayload) ||
                other.userActionPayload == userActionPayload) &&
            (identical(other.userActionHttpMethod, userActionHttpMethod) ||
                other.userActionHttpMethod == userActionHttpMethod) &&
            (identical(other.userActionHttpPath, userActionHttpPath) ||
                other.userActionHttpPath == userActionHttpPath) &&
            (identical(other.userActionServerKind, userActionServerKind) ||
                other.userActionServerKind == userActionServerKind));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userActionPayload,
      userActionHttpMethod, userActionHttpPath, userActionServerKind);

  /// Create a copy of UserActionSigningInitRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserActionSigningInitRequestImplCopyWith<
          _$UserActionSigningInitRequestImpl>
      get copyWith => __$$UserActionSigningInitRequestImplCopyWithImpl<
          _$UserActionSigningInitRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserActionSigningInitRequestImplToJson(
      this,
    );
  }
}

abstract class _UserActionSigningInitRequest
    implements UserActionSigningInitRequest {
  const factory _UserActionSigningInitRequest(
      {required final String userActionPayload,
      required final String userActionHttpMethod,
      required final String userActionHttpPath,
      final String userActionServerKind}) = _$UserActionSigningInitRequestImpl;

  factory _UserActionSigningInitRequest.fromJson(Map<String, dynamic> json) =
      _$UserActionSigningInitRequestImpl.fromJson;

  @override
  String get userActionPayload;
  @override
  String get userActionHttpMethod;
  @override
  String get userActionHttpPath;
  @override
  String get userActionServerKind;

  /// Create a copy of UserActionSigningInitRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserActionSigningInitRequestImplCopyWith<
          _$UserActionSigningInitRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
