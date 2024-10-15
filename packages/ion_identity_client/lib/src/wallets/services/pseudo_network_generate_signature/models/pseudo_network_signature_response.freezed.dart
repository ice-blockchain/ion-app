// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pseudo_network_signature_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PseudoNetworkSignatureResponse _$PseudoNetworkSignatureResponseFromJson(
    Map<String, dynamic> json) {
  return _PseudoNetworkSignatureResponse.fromJson(json);
}

/// @nodoc
mixin _$PseudoNetworkSignatureResponse {
  String get id => throw _privateConstructorUsedError;
  String get walletId => throw _privateConstructorUsedError;
  String get network => throw _privateConstructorUsedError;
  Requester get requester => throw _privateConstructorUsedError;
  Map<String, dynamic> get requestBody => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  Map<String, dynamic> get signature => throw _privateConstructorUsedError;
  DateTime get dateRequested => throw _privateConstructorUsedError;
  DateTime get dateSigned => throw _privateConstructorUsedError;

  /// Serializes this PseudoNetworkSignatureResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PseudoNetworkSignatureResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PseudoNetworkSignatureResponseCopyWith<PseudoNetworkSignatureResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PseudoNetworkSignatureResponseCopyWith<$Res> {
  factory $PseudoNetworkSignatureResponseCopyWith(
          PseudoNetworkSignatureResponse value,
          $Res Function(PseudoNetworkSignatureResponse) then) =
      _$PseudoNetworkSignatureResponseCopyWithImpl<$Res,
          PseudoNetworkSignatureResponse>;
  @useResult
  $Res call(
      {String id,
      String walletId,
      String network,
      Requester requester,
      Map<String, dynamic> requestBody,
      String status,
      Map<String, dynamic> signature,
      DateTime dateRequested,
      DateTime dateSigned});

  $RequesterCopyWith<$Res> get requester;
}

/// @nodoc
class _$PseudoNetworkSignatureResponseCopyWithImpl<$Res,
        $Val extends PseudoNetworkSignatureResponse>
    implements $PseudoNetworkSignatureResponseCopyWith<$Res> {
  _$PseudoNetworkSignatureResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PseudoNetworkSignatureResponse
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
    Object? signature = null,
    Object? dateRequested = null,
    Object? dateSigned = null,
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
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      signature: null == signature
          ? _value.signature
          : signature // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      dateRequested: null == dateRequested
          ? _value.dateRequested
          : dateRequested // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateSigned: null == dateSigned
          ? _value.dateSigned
          : dateSigned // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of PseudoNetworkSignatureResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RequesterCopyWith<$Res> get requester {
    return $RequesterCopyWith<$Res>(_value.requester, (value) {
      return _then(_value.copyWith(requester: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PseudoNetworkSignatureResponseImplCopyWith<$Res>
    implements $PseudoNetworkSignatureResponseCopyWith<$Res> {
  factory _$$PseudoNetworkSignatureResponseImplCopyWith(
          _$PseudoNetworkSignatureResponseImpl value,
          $Res Function(_$PseudoNetworkSignatureResponseImpl) then) =
      __$$PseudoNetworkSignatureResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String walletId,
      String network,
      Requester requester,
      Map<String, dynamic> requestBody,
      String status,
      Map<String, dynamic> signature,
      DateTime dateRequested,
      DateTime dateSigned});

  @override
  $RequesterCopyWith<$Res> get requester;
}

/// @nodoc
class __$$PseudoNetworkSignatureResponseImplCopyWithImpl<$Res>
    extends _$PseudoNetworkSignatureResponseCopyWithImpl<$Res,
        _$PseudoNetworkSignatureResponseImpl>
    implements _$$PseudoNetworkSignatureResponseImplCopyWith<$Res> {
  __$$PseudoNetworkSignatureResponseImplCopyWithImpl(
      _$PseudoNetworkSignatureResponseImpl _value,
      $Res Function(_$PseudoNetworkSignatureResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PseudoNetworkSignatureResponse
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
    Object? signature = null,
    Object? dateRequested = null,
    Object? dateSigned = null,
  }) {
    return _then(_$PseudoNetworkSignatureResponseImpl(
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
          ? _value._requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      signature: null == signature
          ? _value._signature
          : signature // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      dateRequested: null == dateRequested
          ? _value.dateRequested
          : dateRequested // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateSigned: null == dateSigned
          ? _value.dateSigned
          : dateSigned // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PseudoNetworkSignatureResponseImpl
    implements _PseudoNetworkSignatureResponse {
  const _$PseudoNetworkSignatureResponseImpl(
      {required this.id,
      required this.walletId,
      required this.network,
      required this.requester,
      required final Map<String, dynamic> requestBody,
      required this.status,
      required final Map<String, dynamic> signature,
      required this.dateRequested,
      required this.dateSigned})
      : _requestBody = requestBody,
        _signature = signature;

  factory _$PseudoNetworkSignatureResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PseudoNetworkSignatureResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String walletId;
  @override
  final String network;
  @override
  final Requester requester;
  final Map<String, dynamic> _requestBody;
  @override
  Map<String, dynamic> get requestBody {
    if (_requestBody is EqualUnmodifiableMapView) return _requestBody;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_requestBody);
  }

  @override
  final String status;
  final Map<String, dynamic> _signature;
  @override
  Map<String, dynamic> get signature {
    if (_signature is EqualUnmodifiableMapView) return _signature;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_signature);
  }

  @override
  final DateTime dateRequested;
  @override
  final DateTime dateSigned;

  @override
  String toString() {
    return 'PseudoNetworkSignatureResponse(id: $id, walletId: $walletId, network: $network, requester: $requester, requestBody: $requestBody, status: $status, signature: $signature, dateRequested: $dateRequested, dateSigned: $dateSigned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PseudoNetworkSignatureResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId) &&
            (identical(other.network, network) || other.network == network) &&
            (identical(other.requester, requester) ||
                other.requester == requester) &&
            const DeepCollectionEquality()
                .equals(other._requestBody, _requestBody) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._signature, _signature) &&
            (identical(other.dateRequested, dateRequested) ||
                other.dateRequested == dateRequested) &&
            (identical(other.dateSigned, dateSigned) ||
                other.dateSigned == dateSigned));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      walletId,
      network,
      requester,
      const DeepCollectionEquality().hash(_requestBody),
      status,
      const DeepCollectionEquality().hash(_signature),
      dateRequested,
      dateSigned);

  /// Create a copy of PseudoNetworkSignatureResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PseudoNetworkSignatureResponseImplCopyWith<
          _$PseudoNetworkSignatureResponseImpl>
      get copyWith => __$$PseudoNetworkSignatureResponseImplCopyWithImpl<
          _$PseudoNetworkSignatureResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PseudoNetworkSignatureResponseImplToJson(
      this,
    );
  }
}

abstract class _PseudoNetworkSignatureResponse
    implements PseudoNetworkSignatureResponse {
  const factory _PseudoNetworkSignatureResponse(
          {required final String id,
          required final String walletId,
          required final String network,
          required final Requester requester,
          required final Map<String, dynamic> requestBody,
          required final String status,
          required final Map<String, dynamic> signature,
          required final DateTime dateRequested,
          required final DateTime dateSigned}) =
      _$PseudoNetworkSignatureResponseImpl;

  factory _PseudoNetworkSignatureResponse.fromJson(Map<String, dynamic> json) =
      _$PseudoNetworkSignatureResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get walletId;
  @override
  String get network;
  @override
  Requester get requester;
  @override
  Map<String, dynamic> get requestBody;
  @override
  String get status;
  @override
  Map<String, dynamic> get signature;
  @override
  DateTime get dateRequested;
  @override
  DateTime get dateSigned;

  /// Create a copy of PseudoNetworkSignatureResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PseudoNetworkSignatureResponseImplCopyWith<
          _$PseudoNetworkSignatureResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
