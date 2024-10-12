// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_wallets_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetWalletsResponse _$GetWalletsResponseFromJson(Map<String, dynamic> json) {
  return _GetWalletsResponse.fromJson(json);
}

/// @nodoc
mixin _$GetWalletsResponse {
  String get username => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false)
  String? get paginationToken => throw _privateConstructorUsedError;

  /// Serializes this GetWalletsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetWalletsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetWalletsResponseCopyWith<GetWalletsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetWalletsResponseCopyWith<$Res> {
  factory $GetWalletsResponseCopyWith(
          GetWalletsResponse value, $Res Function(GetWalletsResponse) then) =
      _$GetWalletsResponseCopyWithImpl<$Res, GetWalletsResponse>;
  @useResult
  $Res call(
      {String username,
      @JsonKey(includeFromJson: false) String? paginationToken});
}

/// @nodoc
class _$GetWalletsResponseCopyWithImpl<$Res, $Val extends GetWalletsResponse>
    implements $GetWalletsResponseCopyWith<$Res> {
  _$GetWalletsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetWalletsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? paginationToken = freezed,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      paginationToken: freezed == paginationToken
          ? _value.paginationToken
          : paginationToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetWalletsResponseImplCopyWith<$Res>
    implements $GetWalletsResponseCopyWith<$Res> {
  factory _$$GetWalletsResponseImplCopyWith(_$GetWalletsResponseImpl value,
          $Res Function(_$GetWalletsResponseImpl) then) =
      __$$GetWalletsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String username,
      @JsonKey(includeFromJson: false) String? paginationToken});
}

/// @nodoc
class __$$GetWalletsResponseImplCopyWithImpl<$Res>
    extends _$GetWalletsResponseCopyWithImpl<$Res, _$GetWalletsResponseImpl>
    implements _$$GetWalletsResponseImplCopyWith<$Res> {
  __$$GetWalletsResponseImplCopyWithImpl(_$GetWalletsResponseImpl _value,
      $Res Function(_$GetWalletsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetWalletsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? paginationToken = freezed,
  }) {
    return _then(_$GetWalletsResponseImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      paginationToken: freezed == paginationToken
          ? _value.paginationToken
          : paginationToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetWalletsResponseImpl implements _GetWalletsResponse {
  _$GetWalletsResponseImpl(
      {required this.username,
      @JsonKey(includeFromJson: false) required this.paginationToken});

  factory _$GetWalletsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetWalletsResponseImplFromJson(json);

  @override
  final String username;
  @override
  @JsonKey(includeFromJson: false)
  final String? paginationToken;

  @override
  String toString() {
    return 'GetWalletsResponse(username: $username, paginationToken: $paginationToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetWalletsResponseImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.paginationToken, paginationToken) ||
                other.paginationToken == paginationToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, paginationToken);

  /// Create a copy of GetWalletsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetWalletsResponseImplCopyWith<_$GetWalletsResponseImpl> get copyWith =>
      __$$GetWalletsResponseImplCopyWithImpl<_$GetWalletsResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetWalletsResponseImplToJson(
      this,
    );
  }
}

abstract class _GetWalletsResponse implements GetWalletsResponse {
  factory _GetWalletsResponse(
      {required final String username,
      @JsonKey(includeFromJson: false)
      required final String? paginationToken}) = _$GetWalletsResponseImpl;

  factory _GetWalletsResponse.fromJson(Map<String, dynamic> json) =
      _$GetWalletsResponseImpl.fromJson;

  @override
  String get username;
  @override
  @JsonKey(includeFromJson: false)
  String? get paginationToken;

  /// Create a copy of GetWalletsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetWalletsResponseImplCopyWith<_$GetWalletsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
