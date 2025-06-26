// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'secure_payment_confirmation_request.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SecurePaymentConfirmationRequest _$SecurePaymentConfirmationRequestFromJson(
    Map<String, dynamic> json) {
  return _SecurePaymentConfirmationRequest.fromJson(json);
}

/// @nodoc
mixin _$SecurePaymentConfirmationRequest {
  String get kind => throw _privateConstructorUsedError;
  String get transaction => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get authorization => throw _privateConstructorUsedError;

  /// Serializes this SecurePaymentConfirmationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SecurePaymentConfirmationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SecurePaymentConfirmationRequestCopyWith<SecurePaymentConfirmationRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecurePaymentConfirmationRequestCopyWith<$Res> {
  factory $SecurePaymentConfirmationRequestCopyWith(
          SecurePaymentConfirmationRequest value,
          $Res Function(SecurePaymentConfirmationRequest) then) =
      _$SecurePaymentConfirmationRequestCopyWithImpl<$Res,
          SecurePaymentConfirmationRequest>;
  @useResult
  $Res call(
      {String kind,
      String transaction,
      @JsonKey(includeIfNull: false) String? authorization});
}

/// @nodoc
class _$SecurePaymentConfirmationRequestCopyWithImpl<$Res,
        $Val extends SecurePaymentConfirmationRequest>
    implements $SecurePaymentConfirmationRequestCopyWith<$Res> {
  _$SecurePaymentConfirmationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SecurePaymentConfirmationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? transaction = null,
    Object? authorization = freezed,
  }) {
    return _then(_value.copyWith(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      transaction: null == transaction
          ? _value.transaction
          : transaction // ignore: cast_nullable_to_non_nullable
              as String,
      authorization: freezed == authorization
          ? _value.authorization
          : authorization // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SecurePaymentConfirmationRequestImplCopyWith<$Res>
    implements $SecurePaymentConfirmationRequestCopyWith<$Res> {
  factory _$$SecurePaymentConfirmationRequestImplCopyWith(
          _$SecurePaymentConfirmationRequestImpl value,
          $Res Function(_$SecurePaymentConfirmationRequestImpl) then) =
      __$$SecurePaymentConfirmationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String kind,
      String transaction,
      @JsonKey(includeIfNull: false) String? authorization});
}

/// @nodoc
class __$$SecurePaymentConfirmationRequestImplCopyWithImpl<$Res>
    extends _$SecurePaymentConfirmationRequestCopyWithImpl<$Res,
        _$SecurePaymentConfirmationRequestImpl>
    implements _$$SecurePaymentConfirmationRequestImplCopyWith<$Res> {
  __$$SecurePaymentConfirmationRequestImplCopyWithImpl(
      _$SecurePaymentConfirmationRequestImpl _value,
      $Res Function(_$SecurePaymentConfirmationRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SecurePaymentConfirmationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? transaction = null,
    Object? authorization = freezed,
  }) {
    return _then(_$SecurePaymentConfirmationRequestImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      transaction: null == transaction
          ? _value.transaction
          : transaction // ignore: cast_nullable_to_non_nullable
              as String,
      authorization: freezed == authorization
          ? _value.authorization
          : authorization // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SecurePaymentConfirmationRequestImpl
    implements _SecurePaymentConfirmationRequest {
  const _$SecurePaymentConfirmationRequestImpl(
      {required this.kind,
      required this.transaction,
      @JsonKey(includeIfNull: false) this.authorization});

  factory _$SecurePaymentConfirmationRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SecurePaymentConfirmationRequestImplFromJson(json);

  @override
  final String kind;
  @override
  final String transaction;
  @override
  @JsonKey(includeIfNull: false)
  final String? authorization;

  @override
  String toString() {
    return 'SecurePaymentConfirmationRequest(kind: $kind, transaction: $transaction, authorization: $authorization)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SecurePaymentConfirmationRequestImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.transaction, transaction) ||
                other.transaction == transaction) &&
            (identical(other.authorization, authorization) ||
                other.authorization == authorization));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, kind, transaction, authorization);

  /// Create a copy of SecurePaymentConfirmationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SecurePaymentConfirmationRequestImplCopyWith<
          _$SecurePaymentConfirmationRequestImpl>
      get copyWith => __$$SecurePaymentConfirmationRequestImplCopyWithImpl<
          _$SecurePaymentConfirmationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SecurePaymentConfirmationRequestImplToJson(
      this,
    );
  }
}

abstract class _SecurePaymentConfirmationRequest
    implements SecurePaymentConfirmationRequest {
  const factory _SecurePaymentConfirmationRequest(
          {required final String kind,
          required final String transaction,
          @JsonKey(includeIfNull: false) final String? authorization}) =
      _$SecurePaymentConfirmationRequestImpl;

  factory _SecurePaymentConfirmationRequest.fromJson(
          Map<String, dynamic> json) =
      _$SecurePaymentConfirmationRequestImpl.fromJson;

  @override
  String get kind;
  @override
  String get transaction;
  @override
  @JsonKey(includeIfNull: false)
  String? get authorization;

  /// Create a copy of SecurePaymentConfirmationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SecurePaymentConfirmationRequestImplCopyWith<
          _$SecurePaymentConfirmationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
