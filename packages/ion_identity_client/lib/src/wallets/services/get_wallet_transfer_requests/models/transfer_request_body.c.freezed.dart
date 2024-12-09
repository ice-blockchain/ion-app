// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_request_body.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferRequestBody _$TransferRequestBodyFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'native':
      return NativeTransferRequestBody.fromJson(json);
    case 'erc721':
      return Erc721TransferRequestBody.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'TransferRequestBody',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$TransferRequestBody {
  String get kind => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String kind, String to, String amount) native,
    required TResult Function(
            String kind, String contract, String to, String tokenId)
        erc721,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String kind, String to, String amount)? native,
    TResult? Function(String kind, String contract, String to, String tokenId)?
        erc721,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String kind, String to, String amount)? native,
    TResult Function(String kind, String contract, String to, String tokenId)?
        erc721,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NativeTransferRequestBody value) native,
    required TResult Function(Erc721TransferRequestBody value) erc721,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NativeTransferRequestBody value)? native,
    TResult? Function(Erc721TransferRequestBody value)? erc721,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NativeTransferRequestBody value)? native,
    TResult Function(Erc721TransferRequestBody value)? erc721,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this TransferRequestBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferRequestBodyCopyWith<TransferRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferRequestBodyCopyWith<$Res> {
  factory $TransferRequestBodyCopyWith(
          TransferRequestBody value, $Res Function(TransferRequestBody) then) =
      _$TransferRequestBodyCopyWithImpl<$Res, TransferRequestBody>;
  @useResult
  $Res call({String kind, String to});
}

/// @nodoc
class _$TransferRequestBodyCopyWithImpl<$Res, $Val extends TransferRequestBody>
    implements $TransferRequestBodyCopyWith<$Res> {
  _$TransferRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? to = null,
  }) {
    return _then(_value.copyWith(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NativeTransferRequestBodyImplCopyWith<$Res>
    implements $TransferRequestBodyCopyWith<$Res> {
  factory _$$NativeTransferRequestBodyImplCopyWith(
          _$NativeTransferRequestBodyImpl value,
          $Res Function(_$NativeTransferRequestBodyImpl) then) =
      __$$NativeTransferRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String kind, String to, String amount});
}

/// @nodoc
class __$$NativeTransferRequestBodyImplCopyWithImpl<$Res>
    extends _$TransferRequestBodyCopyWithImpl<$Res,
        _$NativeTransferRequestBodyImpl>
    implements _$$NativeTransferRequestBodyImplCopyWith<$Res> {
  __$$NativeTransferRequestBodyImplCopyWithImpl(
      _$NativeTransferRequestBodyImpl _value,
      $Res Function(_$NativeTransferRequestBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? to = null,
    Object? amount = null,
  }) {
    return _then(_$NativeTransferRequestBodyImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NativeTransferRequestBodyImpl implements NativeTransferRequestBody {
  const _$NativeTransferRequestBodyImpl(
      {required this.kind,
      required this.to,
      required this.amount,
      final String? $type})
      : $type = $type ?? 'native';

  factory _$NativeTransferRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$NativeTransferRequestBodyImplFromJson(json);

  @override
  final String kind;
  @override
  final String to;
  @override
  final String amount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TransferRequestBody.native(kind: $kind, to: $to, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NativeTransferRequestBodyImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, to, amount);

  /// Create a copy of TransferRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NativeTransferRequestBodyImplCopyWith<_$NativeTransferRequestBodyImpl>
      get copyWith => __$$NativeTransferRequestBodyImplCopyWithImpl<
          _$NativeTransferRequestBodyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String kind, String to, String amount) native,
    required TResult Function(
            String kind, String contract, String to, String tokenId)
        erc721,
  }) {
    return native(kind, to, amount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String kind, String to, String amount)? native,
    TResult? Function(String kind, String contract, String to, String tokenId)?
        erc721,
  }) {
    return native?.call(kind, to, amount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String kind, String to, String amount)? native,
    TResult Function(String kind, String contract, String to, String tokenId)?
        erc721,
    required TResult orElse(),
  }) {
    if (native != null) {
      return native(kind, to, amount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NativeTransferRequestBody value) native,
    required TResult Function(Erc721TransferRequestBody value) erc721,
  }) {
    return native(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NativeTransferRequestBody value)? native,
    TResult? Function(Erc721TransferRequestBody value)? erc721,
  }) {
    return native?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NativeTransferRequestBody value)? native,
    TResult Function(Erc721TransferRequestBody value)? erc721,
    required TResult orElse(),
  }) {
    if (native != null) {
      return native(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NativeTransferRequestBodyImplToJson(
      this,
    );
  }
}

abstract class NativeTransferRequestBody implements TransferRequestBody {
  const factory NativeTransferRequestBody(
      {required final String kind,
      required final String to,
      required final String amount}) = _$NativeTransferRequestBodyImpl;

  factory NativeTransferRequestBody.fromJson(Map<String, dynamic> json) =
      _$NativeTransferRequestBodyImpl.fromJson;

  @override
  String get kind;
  @override
  String get to;
  String get amount;

  /// Create a copy of TransferRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NativeTransferRequestBodyImplCopyWith<_$NativeTransferRequestBodyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Erc721TransferRequestBodyImplCopyWith<$Res>
    implements $TransferRequestBodyCopyWith<$Res> {
  factory _$$Erc721TransferRequestBodyImplCopyWith(
          _$Erc721TransferRequestBodyImpl value,
          $Res Function(_$Erc721TransferRequestBodyImpl) then) =
      __$$Erc721TransferRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String kind, String contract, String to, String tokenId});
}

/// @nodoc
class __$$Erc721TransferRequestBodyImplCopyWithImpl<$Res>
    extends _$TransferRequestBodyCopyWithImpl<$Res,
        _$Erc721TransferRequestBodyImpl>
    implements _$$Erc721TransferRequestBodyImplCopyWith<$Res> {
  __$$Erc721TransferRequestBodyImplCopyWithImpl(
      _$Erc721TransferRequestBodyImpl _value,
      $Res Function(_$Erc721TransferRequestBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? contract = null,
    Object? to = null,
    Object? tokenId = null,
  }) {
    return _then(_$Erc721TransferRequestBodyImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      contract: null == contract
          ? _value.contract
          : contract // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: null == tokenId
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$Erc721TransferRequestBodyImpl implements Erc721TransferRequestBody {
  const _$Erc721TransferRequestBodyImpl(
      {required this.kind,
      required this.contract,
      required this.to,
      required this.tokenId,
      final String? $type})
      : $type = $type ?? 'erc721';

  factory _$Erc721TransferRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$Erc721TransferRequestBodyImplFromJson(json);

  @override
  final String kind;
  @override
  final String contract;
  @override
  final String to;
  @override
  final String tokenId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TransferRequestBody.erc721(kind: $kind, contract: $contract, to: $to, tokenId: $tokenId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Erc721TransferRequestBodyImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.contract, contract) ||
                other.contract == contract) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.tokenId, tokenId) || other.tokenId == tokenId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, contract, to, tokenId);

  /// Create a copy of TransferRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Erc721TransferRequestBodyImplCopyWith<_$Erc721TransferRequestBodyImpl>
      get copyWith => __$$Erc721TransferRequestBodyImplCopyWithImpl<
          _$Erc721TransferRequestBodyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String kind, String to, String amount) native,
    required TResult Function(
            String kind, String contract, String to, String tokenId)
        erc721,
  }) {
    return erc721(kind, contract, to, tokenId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String kind, String to, String amount)? native,
    TResult? Function(String kind, String contract, String to, String tokenId)?
        erc721,
  }) {
    return erc721?.call(kind, contract, to, tokenId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String kind, String to, String amount)? native,
    TResult Function(String kind, String contract, String to, String tokenId)?
        erc721,
    required TResult orElse(),
  }) {
    if (erc721 != null) {
      return erc721(kind, contract, to, tokenId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NativeTransferRequestBody value) native,
    required TResult Function(Erc721TransferRequestBody value) erc721,
  }) {
    return erc721(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NativeTransferRequestBody value)? native,
    TResult? Function(Erc721TransferRequestBody value)? erc721,
  }) {
    return erc721?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NativeTransferRequestBody value)? native,
    TResult Function(Erc721TransferRequestBody value)? erc721,
    required TResult orElse(),
  }) {
    if (erc721 != null) {
      return erc721(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$Erc721TransferRequestBodyImplToJson(
      this,
    );
  }
}

abstract class Erc721TransferRequestBody implements TransferRequestBody {
  const factory Erc721TransferRequestBody(
      {required final String kind,
      required final String contract,
      required final String to,
      required final String tokenId}) = _$Erc721TransferRequestBodyImpl;

  factory Erc721TransferRequestBody.fromJson(Map<String, dynamic> json) =
      _$Erc721TransferRequestBodyImpl.fromJson;

  @override
  String get kind;
  String get contract;
  @override
  String get to;
  String get tokenId;

  /// Create a copy of TransferRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Erc721TransferRequestBodyImplCopyWith<_$Erc721TransferRequestBodyImpl>
      get copyWith => throw _privateConstructorUsedError;
}
