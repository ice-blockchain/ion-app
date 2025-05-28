// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generate_signature_response.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GenerateSignatureResponse _$GenerateSignatureResponseFromJson(
    Map<String, dynamic> json) {
  return _GenerateSignatureResponse.fromJson(json);
}

/// @nodoc
mixin _$GenerateSignatureResponse {
  String get id => throw _privateConstructorUsedError;
  String get keyId => throw _privateConstructorUsedError;
  Requester get requester => throw _privateConstructorUsedError;
  Map<String, dynamic> get requestBody => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  Map<String, dynamic> get signature => throw _privateConstructorUsedError;
  int get dateRequested => throw _privateConstructorUsedError;
  int get dateSigned => throw _privateConstructorUsedError;

  /// Serializes this GenerateSignatureResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GenerateSignatureResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GenerateSignatureResponseCopyWith<GenerateSignatureResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenerateSignatureResponseCopyWith<$Res> {
  factory $GenerateSignatureResponseCopyWith(GenerateSignatureResponse value,
          $Res Function(GenerateSignatureResponse) then) =
      _$GenerateSignatureResponseCopyWithImpl<$Res, GenerateSignatureResponse>;
  @useResult
  $Res call(
      {String id,
      String keyId,
      Requester requester,
      Map<String, dynamic> requestBody,
      String status,
      Map<String, dynamic> signature,
      int dateRequested,
      int dateSigned});

  $RequesterCopyWith<$Res> get requester;
}

/// @nodoc
class _$GenerateSignatureResponseCopyWithImpl<$Res,
        $Val extends GenerateSignatureResponse>
    implements $GenerateSignatureResponseCopyWith<$Res> {
  _$GenerateSignatureResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GenerateSignatureResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? keyId = null,
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
      keyId: null == keyId
          ? _value.keyId
          : keyId // ignore: cast_nullable_to_non_nullable
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
              as int,
      dateSigned: null == dateSigned
          ? _value.dateSigned
          : dateSigned // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of GenerateSignatureResponse
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
abstract class _$$GenerateSignatureResponseImplCopyWith<$Res>
    implements $GenerateSignatureResponseCopyWith<$Res> {
  factory _$$GenerateSignatureResponseImplCopyWith(
          _$GenerateSignatureResponseImpl value,
          $Res Function(_$GenerateSignatureResponseImpl) then) =
      __$$GenerateSignatureResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String keyId,
      Requester requester,
      Map<String, dynamic> requestBody,
      String status,
      Map<String, dynamic> signature,
      int dateRequested,
      int dateSigned});

  @override
  $RequesterCopyWith<$Res> get requester;
}

/// @nodoc
class __$$GenerateSignatureResponseImplCopyWithImpl<$Res>
    extends _$GenerateSignatureResponseCopyWithImpl<$Res,
        _$GenerateSignatureResponseImpl>
    implements _$$GenerateSignatureResponseImplCopyWith<$Res> {
  __$$GenerateSignatureResponseImplCopyWithImpl(
      _$GenerateSignatureResponseImpl _value,
      $Res Function(_$GenerateSignatureResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GenerateSignatureResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? keyId = null,
    Object? requester = null,
    Object? requestBody = null,
    Object? status = null,
    Object? signature = null,
    Object? dateRequested = null,
    Object? dateSigned = null,
  }) {
    return _then(_$GenerateSignatureResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      keyId: null == keyId
          ? _value.keyId
          : keyId // ignore: cast_nullable_to_non_nullable
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
              as int,
      dateSigned: null == dateSigned
          ? _value.dateSigned
          : dateSigned // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GenerateSignatureResponseImpl implements _GenerateSignatureResponse {
  const _$GenerateSignatureResponseImpl(
      {required this.id,
      required this.keyId,
      required this.requester,
      required final Map<String, dynamic> requestBody,
      required this.status,
      required final Map<String, dynamic> signature,
      required this.dateRequested,
      required this.dateSigned})
      : _requestBody = requestBody,
        _signature = signature;

  factory _$GenerateSignatureResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GenerateSignatureResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String keyId;
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
  final int dateRequested;
  @override
  final int dateSigned;

  @override
  String toString() {
    return 'GenerateSignatureResponse(id: $id, keyId: $keyId, requester: $requester, requestBody: $requestBody, status: $status, signature: $signature, dateRequested: $dateRequested, dateSigned: $dateSigned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenerateSignatureResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.keyId, keyId) || other.keyId == keyId) &&
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
      keyId,
      requester,
      const DeepCollectionEquality().hash(_requestBody),
      status,
      const DeepCollectionEquality().hash(_signature),
      dateRequested,
      dateSigned);

  /// Create a copy of GenerateSignatureResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenerateSignatureResponseImplCopyWith<_$GenerateSignatureResponseImpl>
      get copyWith => __$$GenerateSignatureResponseImplCopyWithImpl<
          _$GenerateSignatureResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GenerateSignatureResponseImplToJson(
      this,
    );
  }
}

abstract class _GenerateSignatureResponse implements GenerateSignatureResponse {
  const factory _GenerateSignatureResponse(
      {required final String id,
      required final String keyId,
      required final Requester requester,
      required final Map<String, dynamic> requestBody,
      required final String status,
      required final Map<String, dynamic> signature,
      required final int dateRequested,
      required final int dateSigned}) = _$GenerateSignatureResponseImpl;

  factory _GenerateSignatureResponse.fromJson(Map<String, dynamic> json) =
      _$GenerateSignatureResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get keyId;
  @override
  Requester get requester;
  @override
  Map<String, dynamic> get requestBody;
  @override
  String get status;
  @override
  Map<String, dynamic> get signature;
  @override
  int get dateRequested;
  @override
  int get dateSigned;

  /// Create a copy of GenerateSignatureResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenerateSignatureResponseImplCopyWith<_$GenerateSignatureResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
