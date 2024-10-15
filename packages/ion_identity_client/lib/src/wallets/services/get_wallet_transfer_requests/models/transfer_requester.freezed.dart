// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_requester.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferRequester _$TransferRequesterFromJson(Map<String, dynamic> json) {
  return _TransferRequester.fromJson(json);
}

/// @nodoc
mixin _$TransferRequester {
  String get userId => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get appId => throw _privateConstructorUsedError;

  /// Serializes this TransferRequester to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferRequester
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferRequesterCopyWith<TransferRequester> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferRequesterCopyWith<$Res> {
  factory $TransferRequesterCopyWith(
          TransferRequester value, $Res Function(TransferRequester) then) =
      _$TransferRequesterCopyWithImpl<$Res, TransferRequester>;
  @useResult
  $Res call({String userId, String tokenId, String appId});
}

/// @nodoc
class _$TransferRequesterCopyWithImpl<$Res, $Val extends TransferRequester>
    implements $TransferRequesterCopyWith<$Res> {
  _$TransferRequesterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferRequester
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? tokenId = null,
    Object? appId = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: null == tokenId
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferRequesterImplCopyWith<$Res>
    implements $TransferRequesterCopyWith<$Res> {
  factory _$$TransferRequesterImplCopyWith(_$TransferRequesterImpl value,
          $Res Function(_$TransferRequesterImpl) then) =
      __$$TransferRequesterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String tokenId, String appId});
}

/// @nodoc
class __$$TransferRequesterImplCopyWithImpl<$Res>
    extends _$TransferRequesterCopyWithImpl<$Res, _$TransferRequesterImpl>
    implements _$$TransferRequesterImplCopyWith<$Res> {
  __$$TransferRequesterImplCopyWithImpl(_$TransferRequesterImpl _value,
      $Res Function(_$TransferRequesterImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferRequester
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? tokenId = null,
    Object? appId = null,
  }) {
    return _then(_$TransferRequesterImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: null == tokenId
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferRequesterImpl implements _TransferRequester {
  const _$TransferRequesterImpl(
      {required this.userId, required this.tokenId, required this.appId});

  factory _$TransferRequesterImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferRequesterImplFromJson(json);

  @override
  final String userId;
  @override
  final String tokenId;
  @override
  final String appId;

  @override
  String toString() {
    return 'TransferRequester(userId: $userId, tokenId: $tokenId, appId: $appId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferRequesterImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.tokenId, tokenId) || other.tokenId == tokenId) &&
            (identical(other.appId, appId) || other.appId == appId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, tokenId, appId);

  /// Create a copy of TransferRequester
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferRequesterImplCopyWith<_$TransferRequesterImpl> get copyWith =>
      __$$TransferRequesterImplCopyWithImpl<_$TransferRequesterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferRequesterImplToJson(
      this,
    );
  }
}

abstract class _TransferRequester implements TransferRequester {
  const factory _TransferRequester(
      {required final String userId,
      required final String tokenId,
      required final String appId}) = _$TransferRequesterImpl;

  factory _TransferRequester.fromJson(Map<String, dynamic> json) =
      _$TransferRequesterImpl.fromJson;

  @override
  String get userId;
  @override
  String get tokenId;
  @override
  String get appId;

  /// Create a copy of TransferRequester
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferRequesterImplCopyWith<_$TransferRequesterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
