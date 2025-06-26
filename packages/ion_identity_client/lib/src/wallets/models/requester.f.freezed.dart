// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'requester.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Requester _$RequesterFromJson(Map<String, dynamic> json) {
  return _Requester.fromJson(json);
}

/// @nodoc
mixin _$Requester {
  String get userId => throw _privateConstructorUsedError;
  String? get tokenId => throw _privateConstructorUsedError;
  String? get appId => throw _privateConstructorUsedError;

  /// Serializes this Requester to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Requester
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequesterCopyWith<Requester> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequesterCopyWith<$Res> {
  factory $RequesterCopyWith(Requester value, $Res Function(Requester) then) =
      _$RequesterCopyWithImpl<$Res, Requester>;
  @useResult
  $Res call({String userId, String? tokenId, String? appId});
}

/// @nodoc
class _$RequesterCopyWithImpl<$Res, $Val extends Requester>
    implements $RequesterCopyWith<$Res> {
  _$RequesterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Requester
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? tokenId = freezed,
    Object? appId = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: freezed == tokenId
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String?,
      appId: freezed == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequesterImplCopyWith<$Res>
    implements $RequesterCopyWith<$Res> {
  factory _$$RequesterImplCopyWith(
          _$RequesterImpl value, $Res Function(_$RequesterImpl) then) =
      __$$RequesterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String? tokenId, String? appId});
}

/// @nodoc
class __$$RequesterImplCopyWithImpl<$Res>
    extends _$RequesterCopyWithImpl<$Res, _$RequesterImpl>
    implements _$$RequesterImplCopyWith<$Res> {
  __$$RequesterImplCopyWithImpl(
      _$RequesterImpl _value, $Res Function(_$RequesterImpl) _then)
      : super(_value, _then);

  /// Create a copy of Requester
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? tokenId = freezed,
    Object? appId = freezed,
  }) {
    return _then(_$RequesterImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: freezed == tokenId
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String?,
      appId: freezed == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequesterImpl implements _Requester {
  const _$RequesterImpl(
      {required this.userId, required this.tokenId, required this.appId});

  factory _$RequesterImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequesterImplFromJson(json);

  @override
  final String userId;
  @override
  final String? tokenId;
  @override
  final String? appId;

  @override
  String toString() {
    return 'Requester(userId: $userId, tokenId: $tokenId, appId: $appId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequesterImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.tokenId, tokenId) || other.tokenId == tokenId) &&
            (identical(other.appId, appId) || other.appId == appId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, tokenId, appId);

  /// Create a copy of Requester
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequesterImplCopyWith<_$RequesterImpl> get copyWith =>
      __$$RequesterImplCopyWithImpl<_$RequesterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequesterImplToJson(
      this,
    );
  }
}

abstract class _Requester implements Requester {
  const factory _Requester(
      {required final String userId,
      required final String? tokenId,
      required final String? appId}) = _$RequesterImpl;

  factory _Requester.fromJson(Map<String, dynamic> json) =
      _$RequesterImpl.fromJson;

  @override
  String get userId;
  @override
  String? get tokenId;
  @override
  String? get appId;

  /// Create a copy of Requester
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequesterImplCopyWith<_$RequesterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
