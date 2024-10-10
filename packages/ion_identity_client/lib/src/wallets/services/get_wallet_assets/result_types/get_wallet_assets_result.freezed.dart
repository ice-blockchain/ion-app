// SPDX-License-Identifier: ice License 1.0

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_wallet_assets_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GetWalletAssetsResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(WalletAssetsDto walletAssets) success,
    required TResult Function(GetWalletAssetsFailure failure) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(WalletAssetsDto walletAssets)? success,
    TResult? Function(GetWalletAssetsFailure failure)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(WalletAssetsDto walletAssets)? success,
    TResult Function(GetWalletAssetsFailure failure)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetWalletAssetsSuccess value) success,
    required TResult Function(_GetWalletAssetsFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetWalletAssetsSuccess value)? success,
    TResult? Function(_GetWalletAssetsFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetWalletAssetsSuccess value)? success,
    TResult Function(_GetWalletAssetsFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetWalletAssetsResultCopyWith<$Res> {
  factory $GetWalletAssetsResultCopyWith(GetWalletAssetsResult value,
          $Res Function(GetWalletAssetsResult) then) =
      _$GetWalletAssetsResultCopyWithImpl<$Res, GetWalletAssetsResult>;
}

/// @nodoc
class _$GetWalletAssetsResultCopyWithImpl<$Res,
        $Val extends GetWalletAssetsResult>
    implements $GetWalletAssetsResultCopyWith<$Res> {
  _$GetWalletAssetsResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetWalletAssetsResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GetWalletAssetsSuccessImplCopyWith<$Res> {
  factory _$$GetWalletAssetsSuccessImplCopyWith(
          _$GetWalletAssetsSuccessImpl value,
          $Res Function(_$GetWalletAssetsSuccessImpl) then) =
      __$$GetWalletAssetsSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WalletAssetsDto walletAssets});

  $WalletAssetsDtoCopyWith<$Res> get walletAssets;
}

/// @nodoc
class __$$GetWalletAssetsSuccessImplCopyWithImpl<$Res>
    extends _$GetWalletAssetsResultCopyWithImpl<$Res,
        _$GetWalletAssetsSuccessImpl>
    implements _$$GetWalletAssetsSuccessImplCopyWith<$Res> {
  __$$GetWalletAssetsSuccessImplCopyWithImpl(
      _$GetWalletAssetsSuccessImpl _value,
      $Res Function(_$GetWalletAssetsSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetWalletAssetsResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletAssets = null,
  }) {
    return _then(_$GetWalletAssetsSuccessImpl(
      null == walletAssets
          ? _value.walletAssets
          : walletAssets // ignore: cast_nullable_to_non_nullable
              as WalletAssetsDto,
    ));
  }

  /// Create a copy of GetWalletAssetsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalletAssetsDtoCopyWith<$Res> get walletAssets {
    return $WalletAssetsDtoCopyWith<$Res>(_value.walletAssets, (value) {
      return _then(_value.copyWith(walletAssets: value));
    });
  }
}

/// @nodoc

class _$GetWalletAssetsSuccessImpl implements _GetWalletAssetsSuccess {
  _$GetWalletAssetsSuccessImpl(this.walletAssets);

  @override
  final WalletAssetsDto walletAssets;

  @override
  String toString() {
    return 'GetWalletAssetsResult.success(walletAssets: $walletAssets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetWalletAssetsSuccessImpl &&
            (identical(other.walletAssets, walletAssets) ||
                other.walletAssets == walletAssets));
  }

  @override
  int get hashCode => Object.hash(runtimeType, walletAssets);

  /// Create a copy of GetWalletAssetsResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetWalletAssetsSuccessImplCopyWith<_$GetWalletAssetsSuccessImpl>
      get copyWith => __$$GetWalletAssetsSuccessImplCopyWithImpl<
          _$GetWalletAssetsSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(WalletAssetsDto walletAssets) success,
    required TResult Function(GetWalletAssetsFailure failure) failure,
  }) {
    return success(walletAssets);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(WalletAssetsDto walletAssets)? success,
    TResult? Function(GetWalletAssetsFailure failure)? failure,
  }) {
    return success?.call(walletAssets);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(WalletAssetsDto walletAssets)? success,
    TResult Function(GetWalletAssetsFailure failure)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(walletAssets);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetWalletAssetsSuccess value) success,
    required TResult Function(_GetWalletAssetsFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetWalletAssetsSuccess value)? success,
    TResult? Function(_GetWalletAssetsFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetWalletAssetsSuccess value)? success,
    TResult Function(_GetWalletAssetsFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _GetWalletAssetsSuccess implements GetWalletAssetsResult {
  factory _GetWalletAssetsSuccess(final WalletAssetsDto walletAssets) =
      _$GetWalletAssetsSuccessImpl;

  WalletAssetsDto get walletAssets;

  /// Create a copy of GetWalletAssetsResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetWalletAssetsSuccessImplCopyWith<_$GetWalletAssetsSuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetWalletAssetsFailureImplCopyWith<$Res> {
  factory _$$GetWalletAssetsFailureImplCopyWith(
          _$GetWalletAssetsFailureImpl value,
          $Res Function(_$GetWalletAssetsFailureImpl) then) =
      __$$GetWalletAssetsFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({GetWalletAssetsFailure failure});

  $GetWalletAssetsFailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$GetWalletAssetsFailureImplCopyWithImpl<$Res>
    extends _$GetWalletAssetsResultCopyWithImpl<$Res,
        _$GetWalletAssetsFailureImpl>
    implements _$$GetWalletAssetsFailureImplCopyWith<$Res> {
  __$$GetWalletAssetsFailureImplCopyWithImpl(
      _$GetWalletAssetsFailureImpl _value,
      $Res Function(_$GetWalletAssetsFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetWalletAssetsResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = null,
  }) {
    return _then(_$GetWalletAssetsFailureImpl(
      null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as GetWalletAssetsFailure,
    ));
  }

  /// Create a copy of GetWalletAssetsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GetWalletAssetsFailureCopyWith<$Res> get failure {
    return $GetWalletAssetsFailureCopyWith<$Res>(_value.failure, (value) {
      return _then(_value.copyWith(failure: value));
    });
  }
}

/// @nodoc

class _$GetWalletAssetsFailureImpl implements _GetWalletAssetsFailure {
  _$GetWalletAssetsFailureImpl(this.failure);

  @override
  final GetWalletAssetsFailure failure;

  @override
  String toString() {
    return 'GetWalletAssetsResult.failure(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetWalletAssetsFailureImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of GetWalletAssetsResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetWalletAssetsFailureImplCopyWith<_$GetWalletAssetsFailureImpl>
      get copyWith => __$$GetWalletAssetsFailureImplCopyWithImpl<
          _$GetWalletAssetsFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(WalletAssetsDto walletAssets) success,
    required TResult Function(GetWalletAssetsFailure failure) failure,
  }) {
    return failure(this.failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(WalletAssetsDto walletAssets)? success,
    TResult? Function(GetWalletAssetsFailure failure)? failure,
  }) {
    return failure?.call(this.failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(WalletAssetsDto walletAssets)? success,
    TResult Function(GetWalletAssetsFailure failure)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this.failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetWalletAssetsSuccess value) success,
    required TResult Function(_GetWalletAssetsFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetWalletAssetsSuccess value)? success,
    TResult? Function(_GetWalletAssetsFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetWalletAssetsSuccess value)? success,
    TResult Function(_GetWalletAssetsFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _GetWalletAssetsFailure implements GetWalletAssetsResult {
  factory _GetWalletAssetsFailure(final GetWalletAssetsFailure failure) =
      _$GetWalletAssetsFailureImpl;

  GetWalletAssetsFailure get failure;

  /// Create a copy of GetWalletAssetsResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetWalletAssetsFailureImplCopyWith<_$GetWalletAssetsFailureImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GetWalletAssetsFailure {
  Object? get error => throw _privateConstructorUsedError;
  StackTrace? get stackTrace => throw _privateConstructorUsedError;

  /// Create a copy of GetWalletAssetsFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetWalletAssetsFailureCopyWith<GetWalletAssetsFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetWalletAssetsFailureCopyWith<$Res> {
  factory $GetWalletAssetsFailureCopyWith(GetWalletAssetsFailure value,
          $Res Function(GetWalletAssetsFailure) then) =
      _$GetWalletAssetsFailureCopyWithImpl<$Res, GetWalletAssetsFailure>;
  @useResult
  $Res call({Object? error, StackTrace? stackTrace});
}

/// @nodoc
class _$GetWalletAssetsFailureCopyWithImpl<$Res,
        $Val extends GetWalletAssetsFailure>
    implements $GetWalletAssetsFailureCopyWith<$Res> {
  _$GetWalletAssetsFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetWalletAssetsFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_value.copyWith(
      error: freezed == error ? _value.error : error,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetWalletAssetsFailureInternalImplCopyWith<$Res>
    implements $GetWalletAssetsFailureCopyWith<$Res> {
  factory _$$GetWalletAssetsFailureInternalImplCopyWith(
          _$GetWalletAssetsFailureInternalImpl value,
          $Res Function(_$GetWalletAssetsFailureInternalImpl) then) =
      __$$GetWalletAssetsFailureInternalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Object? error, StackTrace? stackTrace});
}

/// @nodoc
class __$$GetWalletAssetsFailureInternalImplCopyWithImpl<$Res>
    extends _$GetWalletAssetsFailureCopyWithImpl<$Res,
        _$GetWalletAssetsFailureInternalImpl>
    implements _$$GetWalletAssetsFailureInternalImplCopyWith<$Res> {
  __$$GetWalletAssetsFailureInternalImplCopyWithImpl(
      _$GetWalletAssetsFailureInternalImpl _value,
      $Res Function(_$GetWalletAssetsFailureInternalImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetWalletAssetsFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_$GetWalletAssetsFailureInternalImpl(
      freezed == error ? _value.error : error,
      freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _$GetWalletAssetsFailureInternalImpl
    implements _GetWalletAssetsFailureInternal {
  _$GetWalletAssetsFailureInternalImpl([this.error, this.stackTrace]);

  @override
  final Object? error;
  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'GetWalletAssetsFailure(error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetWalletAssetsFailureInternalImpl &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(error), stackTrace);

  /// Create a copy of GetWalletAssetsFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetWalletAssetsFailureInternalImplCopyWith<
          _$GetWalletAssetsFailureInternalImpl>
      get copyWith => __$$GetWalletAssetsFailureInternalImplCopyWithImpl<
          _$GetWalletAssetsFailureInternalImpl>(this, _$identity);
}

abstract class _GetWalletAssetsFailureInternal
    implements GetWalletAssetsFailure {
  factory _GetWalletAssetsFailureInternal(
      [final Object? error,
      final StackTrace? stackTrace]) = _$GetWalletAssetsFailureInternalImpl;

  @override
  Object? get error;
  @override
  StackTrace? get stackTrace;

  /// Create a copy of GetWalletAssetsFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetWalletAssetsFailureInternalImplCopyWith<
          _$GetWalletAssetsFailureInternalImpl>
      get copyWith => throw _privateConstructorUsedError;
}
