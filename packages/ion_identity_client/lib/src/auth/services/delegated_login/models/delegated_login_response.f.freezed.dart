// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delegated_login_response.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DelegatedLoginResponse _$DelegatedLoginResponseFromJson(
    Map<String, dynamic> json) {
  return _DelegatedLoginResponse.fromJson(json);
}

/// @nodoc
mixin _$DelegatedLoginResponse {
  String get token => throw _privateConstructorUsedError;

  /// Serializes this DelegatedLoginResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DelegatedLoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DelegatedLoginResponseCopyWith<DelegatedLoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DelegatedLoginResponseCopyWith<$Res> {
  factory $DelegatedLoginResponseCopyWith(DelegatedLoginResponse value,
          $Res Function(DelegatedLoginResponse) then) =
      _$DelegatedLoginResponseCopyWithImpl<$Res, DelegatedLoginResponse>;
  @useResult
  $Res call({String token});
}

/// @nodoc
class _$DelegatedLoginResponseCopyWithImpl<$Res,
        $Val extends DelegatedLoginResponse>
    implements $DelegatedLoginResponseCopyWith<$Res> {
  _$DelegatedLoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DelegatedLoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DelegatedLoginResponseImplCopyWith<$Res>
    implements $DelegatedLoginResponseCopyWith<$Res> {
  factory _$$DelegatedLoginResponseImplCopyWith(
          _$DelegatedLoginResponseImpl value,
          $Res Function(_$DelegatedLoginResponseImpl) then) =
      __$$DelegatedLoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token});
}

/// @nodoc
class __$$DelegatedLoginResponseImplCopyWithImpl<$Res>
    extends _$DelegatedLoginResponseCopyWithImpl<$Res,
        _$DelegatedLoginResponseImpl>
    implements _$$DelegatedLoginResponseImplCopyWith<$Res> {
  __$$DelegatedLoginResponseImplCopyWithImpl(
      _$DelegatedLoginResponseImpl _value,
      $Res Function(_$DelegatedLoginResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DelegatedLoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_$DelegatedLoginResponseImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DelegatedLoginResponseImpl implements _DelegatedLoginResponse {
  const _$DelegatedLoginResponseImpl({required this.token});

  factory _$DelegatedLoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DelegatedLoginResponseImplFromJson(json);

  @override
  final String token;

  @override
  String toString() {
    return 'DelegatedLoginResponse(token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DelegatedLoginResponseImpl &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  /// Create a copy of DelegatedLoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DelegatedLoginResponseImplCopyWith<_$DelegatedLoginResponseImpl>
      get copyWith => __$$DelegatedLoginResponseImplCopyWithImpl<
          _$DelegatedLoginResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DelegatedLoginResponseImplToJson(
      this,
    );
  }
}

abstract class _DelegatedLoginResponse implements DelegatedLoginResponse {
  const factory _DelegatedLoginResponse({required final String token}) =
      _$DelegatedLoginResponseImpl;

  factory _DelegatedLoginResponse.fromJson(Map<String, dynamic> json) =
      _$DelegatedLoginResponseImpl.fromJson;

  @override
  String get token;

  /// Create a copy of DelegatedLoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DelegatedLoginResponseImplCopyWith<_$DelegatedLoginResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
