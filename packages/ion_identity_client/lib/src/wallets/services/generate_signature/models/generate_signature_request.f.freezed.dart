// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generate_signature_request.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SignatureRequestHash _$SignatureRequestHashFromJson(Map<String, dynamic> json) {
  return _SignatureRequestHash.fromJson(json);
}

/// @nodoc
mixin _$SignatureRequestHash {
  String get kind => throw _privateConstructorUsedError;
  String get hash => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get externalId => throw _privateConstructorUsedError;

  /// Serializes this SignatureRequestHash to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignatureRequestHash
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignatureRequestHashCopyWith<SignatureRequestHash> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignatureRequestHashCopyWith<$Res> {
  factory $SignatureRequestHashCopyWith(SignatureRequestHash value,
          $Res Function(SignatureRequestHash) then) =
      _$SignatureRequestHashCopyWithImpl<$Res, SignatureRequestHash>;
  @useResult
  $Res call(
      {String kind,
      String hash,
      @JsonKey(includeIfNull: false) String? externalId});
}

/// @nodoc
class _$SignatureRequestHashCopyWithImpl<$Res,
        $Val extends SignatureRequestHash>
    implements $SignatureRequestHashCopyWith<$Res> {
  _$SignatureRequestHashCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignatureRequestHash
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? hash = null,
    Object? externalId = freezed,
  }) {
    return _then(_value.copyWith(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      hash: null == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
      externalId: freezed == externalId
          ? _value.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignatureRequestHashImplCopyWith<$Res>
    implements $SignatureRequestHashCopyWith<$Res> {
  factory _$$SignatureRequestHashImplCopyWith(_$SignatureRequestHashImpl value,
          $Res Function(_$SignatureRequestHashImpl) then) =
      __$$SignatureRequestHashImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String kind,
      String hash,
      @JsonKey(includeIfNull: false) String? externalId});
}

/// @nodoc
class __$$SignatureRequestHashImplCopyWithImpl<$Res>
    extends _$SignatureRequestHashCopyWithImpl<$Res, _$SignatureRequestHashImpl>
    implements _$$SignatureRequestHashImplCopyWith<$Res> {
  __$$SignatureRequestHashImplCopyWithImpl(_$SignatureRequestHashImpl _value,
      $Res Function(_$SignatureRequestHashImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignatureRequestHash
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? hash = null,
    Object? externalId = freezed,
  }) {
    return _then(_$SignatureRequestHashImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      hash: null == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
      externalId: freezed == externalId
          ? _value.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SignatureRequestHashImpl implements _SignatureRequestHash {
  const _$SignatureRequestHashImpl(
      {required this.kind,
      required this.hash,
      @JsonKey(includeIfNull: false) this.externalId});

  factory _$SignatureRequestHashImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignatureRequestHashImplFromJson(json);

  @override
  final String kind;
  @override
  final String hash;
  @override
  @JsonKey(includeIfNull: false)
  final String? externalId;

  @override
  String toString() {
    return 'SignatureRequestHash(kind: $kind, hash: $hash, externalId: $externalId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignatureRequestHashImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.hash, hash) || other.hash == hash) &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, hash, externalId);

  /// Create a copy of SignatureRequestHash
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignatureRequestHashImplCopyWith<_$SignatureRequestHashImpl>
      get copyWith =>
          __$$SignatureRequestHashImplCopyWithImpl<_$SignatureRequestHashImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignatureRequestHashImplToJson(
      this,
    );
  }
}

abstract class _SignatureRequestHash implements SignatureRequestHash {
  const factory _SignatureRequestHash(
          {required final String kind,
          required final String hash,
          @JsonKey(includeIfNull: false) final String? externalId}) =
      _$SignatureRequestHashImpl;

  factory _SignatureRequestHash.fromJson(Map<String, dynamic> json) =
      _$SignatureRequestHashImpl.fromJson;

  @override
  String get kind;
  @override
  String get hash;
  @override
  @JsonKey(includeIfNull: false)
  String? get externalId;

  /// Create a copy of SignatureRequestHash
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignatureRequestHashImplCopyWith<_$SignatureRequestHashImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SignatureRequestMessage _$SignatureRequestMessageFromJson(
    Map<String, dynamic> json) {
  return _SignatureRequestMessage.fromJson(json);
}

/// @nodoc
mixin _$SignatureRequestMessage {
  String get kind => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get externalId => throw _privateConstructorUsedError;

  /// Serializes this SignatureRequestMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignatureRequestMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignatureRequestMessageCopyWith<SignatureRequestMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignatureRequestMessageCopyWith<$Res> {
  factory $SignatureRequestMessageCopyWith(SignatureRequestMessage value,
          $Res Function(SignatureRequestMessage) then) =
      _$SignatureRequestMessageCopyWithImpl<$Res, SignatureRequestMessage>;
  @useResult
  $Res call(
      {String kind,
      String message,
      @JsonKey(includeIfNull: false) String? externalId});
}

/// @nodoc
class _$SignatureRequestMessageCopyWithImpl<$Res,
        $Val extends SignatureRequestMessage>
    implements $SignatureRequestMessageCopyWith<$Res> {
  _$SignatureRequestMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignatureRequestMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? message = null,
    Object? externalId = freezed,
  }) {
    return _then(_value.copyWith(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      externalId: freezed == externalId
          ? _value.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignatureRequestMessageImplCopyWith<$Res>
    implements $SignatureRequestMessageCopyWith<$Res> {
  factory _$$SignatureRequestMessageImplCopyWith(
          _$SignatureRequestMessageImpl value,
          $Res Function(_$SignatureRequestMessageImpl) then) =
      __$$SignatureRequestMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String kind,
      String message,
      @JsonKey(includeIfNull: false) String? externalId});
}

/// @nodoc
class __$$SignatureRequestMessageImplCopyWithImpl<$Res>
    extends _$SignatureRequestMessageCopyWithImpl<$Res,
        _$SignatureRequestMessageImpl>
    implements _$$SignatureRequestMessageImplCopyWith<$Res> {
  __$$SignatureRequestMessageImplCopyWithImpl(
      _$SignatureRequestMessageImpl _value,
      $Res Function(_$SignatureRequestMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignatureRequestMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? message = null,
    Object? externalId = freezed,
  }) {
    return _then(_$SignatureRequestMessageImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      externalId: freezed == externalId
          ? _value.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SignatureRequestMessageImpl implements _SignatureRequestMessage {
  const _$SignatureRequestMessageImpl(
      {required this.kind,
      required this.message,
      @JsonKey(includeIfNull: false) this.externalId});

  factory _$SignatureRequestMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignatureRequestMessageImplFromJson(json);

  @override
  final String kind;
  @override
  final String message;
  @override
  @JsonKey(includeIfNull: false)
  final String? externalId;

  @override
  String toString() {
    return 'SignatureRequestMessage(kind: $kind, message: $message, externalId: $externalId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignatureRequestMessageImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, message, externalId);

  /// Create a copy of SignatureRequestMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignatureRequestMessageImplCopyWith<_$SignatureRequestMessageImpl>
      get copyWith => __$$SignatureRequestMessageImplCopyWithImpl<
          _$SignatureRequestMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignatureRequestMessageImplToJson(
      this,
    );
  }
}

abstract class _SignatureRequestMessage implements SignatureRequestMessage {
  const factory _SignatureRequestMessage(
          {required final String kind,
          required final String message,
          @JsonKey(includeIfNull: false) final String? externalId}) =
      _$SignatureRequestMessageImpl;

  factory _SignatureRequestMessage.fromJson(Map<String, dynamic> json) =
      _$SignatureRequestMessageImpl.fromJson;

  @override
  String get kind;
  @override
  String get message;
  @override
  @JsonKey(includeIfNull: false)
  String? get externalId;

  /// Create a copy of SignatureRequestMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignatureRequestMessageImplCopyWith<_$SignatureRequestMessageImpl>
      get copyWith => throw _privateConstructorUsedError;
}
