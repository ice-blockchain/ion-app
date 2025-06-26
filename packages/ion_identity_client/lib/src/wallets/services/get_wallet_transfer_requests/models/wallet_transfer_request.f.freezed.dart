// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_transfer_request.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletTransferRequest _$WalletTransferRequestFromJson(
    Map<String, dynamic> json) {
  return _WalletTransferRequest.fromJson(json);
}

/// @nodoc
mixin _$WalletTransferRequest {
  String get id => throw _privateConstructorUsedError;
  String get walletId => throw _privateConstructorUsedError;
  String get network => throw _privateConstructorUsedError;
  Requester get requester => throw _privateConstructorUsedError;
  TransferRequestBody get requestBody => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get dateRequested => throw _privateConstructorUsedError;
  String? get txHash => throw _privateConstructorUsedError;
  String? get fee => throw _privateConstructorUsedError;
  DateTime? get dateBroadcasted => throw _privateConstructorUsedError;
  DateTime? get dateConfirmed => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this WalletTransferRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletTransferRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletTransferRequestCopyWith<WalletTransferRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletTransferRequestCopyWith<$Res> {
  factory $WalletTransferRequestCopyWith(WalletTransferRequest value,
          $Res Function(WalletTransferRequest) then) =
      _$WalletTransferRequestCopyWithImpl<$Res, WalletTransferRequest>;
  @useResult
  $Res call(
      {String id,
      String walletId,
      String network,
      Requester requester,
      TransferRequestBody requestBody,
      String status,
      DateTime dateRequested,
      String? txHash,
      String? fee,
      DateTime? dateBroadcasted,
      DateTime? dateConfirmed,
      String? reason,
      Map<String, dynamic>? metadata});

  $RequesterCopyWith<$Res> get requester;
  $TransferRequestBodyCopyWith<$Res> get requestBody;
}

/// @nodoc
class _$WalletTransferRequestCopyWithImpl<$Res,
        $Val extends WalletTransferRequest>
    implements $WalletTransferRequestCopyWith<$Res> {
  _$WalletTransferRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletTransferRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? walletId = null,
    Object? network = null,
    Object? requester = null,
    Object? requestBody = null,
    Object? status = null,
    Object? dateRequested = null,
    Object? txHash = freezed,
    Object? fee = freezed,
    Object? dateBroadcasted = freezed,
    Object? dateConfirmed = freezed,
    Object? reason = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      requester: null == requester
          ? _value.requester
          : requester // ignore: cast_nullable_to_non_nullable
              as Requester,
      requestBody: null == requestBody
          ? _value.requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as TransferRequestBody,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      dateRequested: null == dateRequested
          ? _value.dateRequested
          : dateRequested // ignore: cast_nullable_to_non_nullable
              as DateTime,
      txHash: freezed == txHash
          ? _value.txHash
          : txHash // ignore: cast_nullable_to_non_nullable
              as String?,
      fee: freezed == fee
          ? _value.fee
          : fee // ignore: cast_nullable_to_non_nullable
              as String?,
      dateBroadcasted: freezed == dateBroadcasted
          ? _value.dateBroadcasted
          : dateBroadcasted // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateConfirmed: freezed == dateConfirmed
          ? _value.dateConfirmed
          : dateConfirmed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of WalletTransferRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RequesterCopyWith<$Res> get requester {
    return $RequesterCopyWith<$Res>(_value.requester, (value) {
      return _then(_value.copyWith(requester: value) as $Val);
    });
  }

  /// Create a copy of WalletTransferRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferRequestBodyCopyWith<$Res> get requestBody {
    return $TransferRequestBodyCopyWith<$Res>(_value.requestBody, (value) {
      return _then(_value.copyWith(requestBody: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WalletTransferRequestImplCopyWith<$Res>
    implements $WalletTransferRequestCopyWith<$Res> {
  factory _$$WalletTransferRequestImplCopyWith(
          _$WalletTransferRequestImpl value,
          $Res Function(_$WalletTransferRequestImpl) then) =
      __$$WalletTransferRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String walletId,
      String network,
      Requester requester,
      TransferRequestBody requestBody,
      String status,
      DateTime dateRequested,
      String? txHash,
      String? fee,
      DateTime? dateBroadcasted,
      DateTime? dateConfirmed,
      String? reason,
      Map<String, dynamic>? metadata});

  @override
  $RequesterCopyWith<$Res> get requester;
  @override
  $TransferRequestBodyCopyWith<$Res> get requestBody;
}

/// @nodoc
class __$$WalletTransferRequestImplCopyWithImpl<$Res>
    extends _$WalletTransferRequestCopyWithImpl<$Res,
        _$WalletTransferRequestImpl>
    implements _$$WalletTransferRequestImplCopyWith<$Res> {
  __$$WalletTransferRequestImplCopyWithImpl(_$WalletTransferRequestImpl _value,
      $Res Function(_$WalletTransferRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletTransferRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? walletId = null,
    Object? network = null,
    Object? requester = null,
    Object? requestBody = null,
    Object? status = null,
    Object? dateRequested = null,
    Object? txHash = freezed,
    Object? fee = freezed,
    Object? dateBroadcasted = freezed,
    Object? dateConfirmed = freezed,
    Object? reason = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$WalletTransferRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      requester: null == requester
          ? _value.requester
          : requester // ignore: cast_nullable_to_non_nullable
              as Requester,
      requestBody: null == requestBody
          ? _value.requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as TransferRequestBody,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      dateRequested: null == dateRequested
          ? _value.dateRequested
          : dateRequested // ignore: cast_nullable_to_non_nullable
              as DateTime,
      txHash: freezed == txHash
          ? _value.txHash
          : txHash // ignore: cast_nullable_to_non_nullable
              as String?,
      fee: freezed == fee
          ? _value.fee
          : fee // ignore: cast_nullable_to_non_nullable
              as String?,
      dateBroadcasted: freezed == dateBroadcasted
          ? _value.dateBroadcasted
          : dateBroadcasted // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateConfirmed: freezed == dateConfirmed
          ? _value.dateConfirmed
          : dateConfirmed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletTransferRequestImpl implements _WalletTransferRequest {
  const _$WalletTransferRequestImpl(
      {required this.id,
      required this.walletId,
      required this.network,
      required this.requester,
      required this.requestBody,
      required this.status,
      required this.dateRequested,
      this.txHash,
      this.fee,
      this.dateBroadcasted,
      this.dateConfirmed,
      this.reason,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$WalletTransferRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletTransferRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String walletId;
  @override
  final String network;
  @override
  final Requester requester;
  @override
  final TransferRequestBody requestBody;
  @override
  final String status;
  @override
  final DateTime dateRequested;
  @override
  final String? txHash;
  @override
  final String? fee;
  @override
  final DateTime? dateBroadcasted;
  @override
  final DateTime? dateConfirmed;
  @override
  final String? reason;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'WalletTransferRequest(id: $id, walletId: $walletId, network: $network, requester: $requester, requestBody: $requestBody, status: $status, dateRequested: $dateRequested, txHash: $txHash, fee: $fee, dateBroadcasted: $dateBroadcasted, dateConfirmed: $dateConfirmed, reason: $reason, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletTransferRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId) &&
            (identical(other.network, network) || other.network == network) &&
            (identical(other.requester, requester) ||
                other.requester == requester) &&
            (identical(other.requestBody, requestBody) ||
                other.requestBody == requestBody) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dateRequested, dateRequested) ||
                other.dateRequested == dateRequested) &&
            (identical(other.txHash, txHash) || other.txHash == txHash) &&
            (identical(other.fee, fee) || other.fee == fee) &&
            (identical(other.dateBroadcasted, dateBroadcasted) ||
                other.dateBroadcasted == dateBroadcasted) &&
            (identical(other.dateConfirmed, dateConfirmed) ||
                other.dateConfirmed == dateConfirmed) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      walletId,
      network,
      requester,
      requestBody,
      status,
      dateRequested,
      txHash,
      fee,
      dateBroadcasted,
      dateConfirmed,
      reason,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of WalletTransferRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletTransferRequestImplCopyWith<_$WalletTransferRequestImpl>
      get copyWith => __$$WalletTransferRequestImplCopyWithImpl<
          _$WalletTransferRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletTransferRequestImplToJson(
      this,
    );
  }
}

abstract class _WalletTransferRequest implements WalletTransferRequest {
  const factory _WalletTransferRequest(
      {required final String id,
      required final String walletId,
      required final String network,
      required final Requester requester,
      required final TransferRequestBody requestBody,
      required final String status,
      required final DateTime dateRequested,
      final String? txHash,
      final String? fee,
      final DateTime? dateBroadcasted,
      final DateTime? dateConfirmed,
      final String? reason,
      final Map<String, dynamic>? metadata}) = _$WalletTransferRequestImpl;

  factory _WalletTransferRequest.fromJson(Map<String, dynamic> json) =
      _$WalletTransferRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get walletId;
  @override
  String get network;
  @override
  Requester get requester;
  @override
  TransferRequestBody get requestBody;
  @override
  String get status;
  @override
  DateTime get dateRequested;
  @override
  String? get txHash;
  @override
  String? get fee;
  @override
  DateTime? get dateBroadcasted;
  @override
  DateTime? get dateConfirmed;
  @override
  String? get reason;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of WalletTransferRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletTransferRequestImplCopyWith<_$WalletTransferRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
