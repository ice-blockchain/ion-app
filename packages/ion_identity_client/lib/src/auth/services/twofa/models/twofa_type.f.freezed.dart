// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'twofa_type.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TwoFAType {
  String? get value => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? value) email,
    required TResult Function(String? value) sms,
    required TResult Function(String? value) authenticator,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? value)? email,
    TResult? Function(String? value)? sms,
    TResult? Function(String? value)? authenticator,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? value)? email,
    TResult Function(String? value)? sms,
    TResult Function(String? value)? authenticator,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TwoFATypeEmail value) email,
    required TResult Function(_TwoFATypeSms value) sms,
    required TResult Function(_TwoFATypeAuthenticator value) authenticator,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TwoFATypeEmail value)? email,
    TResult? Function(_TwoFATypeSms value)? sms,
    TResult? Function(_TwoFATypeAuthenticator value)? authenticator,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TwoFATypeEmail value)? email,
    TResult Function(_TwoFATypeSms value)? sms,
    TResult Function(_TwoFATypeAuthenticator value)? authenticator,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of TwoFAType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TwoFATypeCopyWith<TwoFAType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TwoFATypeCopyWith<$Res> {
  factory $TwoFATypeCopyWith(TwoFAType value, $Res Function(TwoFAType) then) =
      _$TwoFATypeCopyWithImpl<$Res, TwoFAType>;
  @useResult
  $Res call({String? value});
}

/// @nodoc
class _$TwoFATypeCopyWithImpl<$Res, $Val extends TwoFAType>
    implements $TwoFATypeCopyWith<$Res> {
  _$TwoFATypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TwoFAType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TwoFATypeEmailImplCopyWith<$Res>
    implements $TwoFATypeCopyWith<$Res> {
  factory _$$TwoFATypeEmailImplCopyWith(_$TwoFATypeEmailImpl value,
          $Res Function(_$TwoFATypeEmailImpl) then) =
      __$$TwoFATypeEmailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? value});
}

/// @nodoc
class __$$TwoFATypeEmailImplCopyWithImpl<$Res>
    extends _$TwoFATypeCopyWithImpl<$Res, _$TwoFATypeEmailImpl>
    implements _$$TwoFATypeEmailImplCopyWith<$Res> {
  __$$TwoFATypeEmailImplCopyWithImpl(
      _$TwoFATypeEmailImpl _value, $Res Function(_$TwoFATypeEmailImpl) _then)
      : super(_value, _then);

  /// Create a copy of TwoFAType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_$TwoFATypeEmailImpl(
      freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TwoFATypeEmailImpl extends _TwoFATypeEmail {
  const _$TwoFATypeEmailImpl([this.value]) : super._();

  @override
  final String? value;

  @override
  String toString() {
    return 'TwoFAType.email(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TwoFATypeEmailImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  /// Create a copy of TwoFAType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TwoFATypeEmailImplCopyWith<_$TwoFATypeEmailImpl> get copyWith =>
      __$$TwoFATypeEmailImplCopyWithImpl<_$TwoFATypeEmailImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? value) email,
    required TResult Function(String? value) sms,
    required TResult Function(String? value) authenticator,
  }) {
    return email(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? value)? email,
    TResult? Function(String? value)? sms,
    TResult? Function(String? value)? authenticator,
  }) {
    return email?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? value)? email,
    TResult Function(String? value)? sms,
    TResult Function(String? value)? authenticator,
    required TResult orElse(),
  }) {
    if (email != null) {
      return email(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TwoFATypeEmail value) email,
    required TResult Function(_TwoFATypeSms value) sms,
    required TResult Function(_TwoFATypeAuthenticator value) authenticator,
  }) {
    return email(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TwoFATypeEmail value)? email,
    TResult? Function(_TwoFATypeSms value)? sms,
    TResult? Function(_TwoFATypeAuthenticator value)? authenticator,
  }) {
    return email?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TwoFATypeEmail value)? email,
    TResult Function(_TwoFATypeSms value)? sms,
    TResult Function(_TwoFATypeAuthenticator value)? authenticator,
    required TResult orElse(),
  }) {
    if (email != null) {
      return email(this);
    }
    return orElse();
  }
}

abstract class _TwoFATypeEmail extends TwoFAType {
  const factory _TwoFATypeEmail([final String? value]) = _$TwoFATypeEmailImpl;
  const _TwoFATypeEmail._() : super._();

  @override
  String? get value;

  /// Create a copy of TwoFAType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TwoFATypeEmailImplCopyWith<_$TwoFATypeEmailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TwoFATypeSmsImplCopyWith<$Res>
    implements $TwoFATypeCopyWith<$Res> {
  factory _$$TwoFATypeSmsImplCopyWith(
          _$TwoFATypeSmsImpl value, $Res Function(_$TwoFATypeSmsImpl) then) =
      __$$TwoFATypeSmsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? value});
}

/// @nodoc
class __$$TwoFATypeSmsImplCopyWithImpl<$Res>
    extends _$TwoFATypeCopyWithImpl<$Res, _$TwoFATypeSmsImpl>
    implements _$$TwoFATypeSmsImplCopyWith<$Res> {
  __$$TwoFATypeSmsImplCopyWithImpl(
      _$TwoFATypeSmsImpl _value, $Res Function(_$TwoFATypeSmsImpl) _then)
      : super(_value, _then);

  /// Create a copy of TwoFAType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_$TwoFATypeSmsImpl(
      freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TwoFATypeSmsImpl extends _TwoFATypeSms {
  const _$TwoFATypeSmsImpl([this.value]) : super._();

  @override
  final String? value;

  @override
  String toString() {
    return 'TwoFAType.sms(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TwoFATypeSmsImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  /// Create a copy of TwoFAType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TwoFATypeSmsImplCopyWith<_$TwoFATypeSmsImpl> get copyWith =>
      __$$TwoFATypeSmsImplCopyWithImpl<_$TwoFATypeSmsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? value) email,
    required TResult Function(String? value) sms,
    required TResult Function(String? value) authenticator,
  }) {
    return sms(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? value)? email,
    TResult? Function(String? value)? sms,
    TResult? Function(String? value)? authenticator,
  }) {
    return sms?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? value)? email,
    TResult Function(String? value)? sms,
    TResult Function(String? value)? authenticator,
    required TResult orElse(),
  }) {
    if (sms != null) {
      return sms(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TwoFATypeEmail value) email,
    required TResult Function(_TwoFATypeSms value) sms,
    required TResult Function(_TwoFATypeAuthenticator value) authenticator,
  }) {
    return sms(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TwoFATypeEmail value)? email,
    TResult? Function(_TwoFATypeSms value)? sms,
    TResult? Function(_TwoFATypeAuthenticator value)? authenticator,
  }) {
    return sms?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TwoFATypeEmail value)? email,
    TResult Function(_TwoFATypeSms value)? sms,
    TResult Function(_TwoFATypeAuthenticator value)? authenticator,
    required TResult orElse(),
  }) {
    if (sms != null) {
      return sms(this);
    }
    return orElse();
  }
}

abstract class _TwoFATypeSms extends TwoFAType {
  const factory _TwoFATypeSms([final String? value]) = _$TwoFATypeSmsImpl;
  const _TwoFATypeSms._() : super._();

  @override
  String? get value;

  /// Create a copy of TwoFAType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TwoFATypeSmsImplCopyWith<_$TwoFATypeSmsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TwoFATypeAuthenticatorImplCopyWith<$Res>
    implements $TwoFATypeCopyWith<$Res> {
  factory _$$TwoFATypeAuthenticatorImplCopyWith(
          _$TwoFATypeAuthenticatorImpl value,
          $Res Function(_$TwoFATypeAuthenticatorImpl) then) =
      __$$TwoFATypeAuthenticatorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? value});
}

/// @nodoc
class __$$TwoFATypeAuthenticatorImplCopyWithImpl<$Res>
    extends _$TwoFATypeCopyWithImpl<$Res, _$TwoFATypeAuthenticatorImpl>
    implements _$$TwoFATypeAuthenticatorImplCopyWith<$Res> {
  __$$TwoFATypeAuthenticatorImplCopyWithImpl(
      _$TwoFATypeAuthenticatorImpl _value,
      $Res Function(_$TwoFATypeAuthenticatorImpl) _then)
      : super(_value, _then);

  /// Create a copy of TwoFAType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_$TwoFATypeAuthenticatorImpl(
      freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TwoFATypeAuthenticatorImpl extends _TwoFATypeAuthenticator {
  const _$TwoFATypeAuthenticatorImpl([this.value]) : super._();

  @override
  final String? value;

  @override
  String toString() {
    return 'TwoFAType.authenticator(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TwoFATypeAuthenticatorImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  /// Create a copy of TwoFAType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TwoFATypeAuthenticatorImplCopyWith<_$TwoFATypeAuthenticatorImpl>
      get copyWith => __$$TwoFATypeAuthenticatorImplCopyWithImpl<
          _$TwoFATypeAuthenticatorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? value) email,
    required TResult Function(String? value) sms,
    required TResult Function(String? value) authenticator,
  }) {
    return authenticator(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? value)? email,
    TResult? Function(String? value)? sms,
    TResult? Function(String? value)? authenticator,
  }) {
    return authenticator?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? value)? email,
    TResult Function(String? value)? sms,
    TResult Function(String? value)? authenticator,
    required TResult orElse(),
  }) {
    if (authenticator != null) {
      return authenticator(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TwoFATypeEmail value) email,
    required TResult Function(_TwoFATypeSms value) sms,
    required TResult Function(_TwoFATypeAuthenticator value) authenticator,
  }) {
    return authenticator(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TwoFATypeEmail value)? email,
    TResult? Function(_TwoFATypeSms value)? sms,
    TResult? Function(_TwoFATypeAuthenticator value)? authenticator,
  }) {
    return authenticator?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TwoFATypeEmail value)? email,
    TResult Function(_TwoFATypeSms value)? sms,
    TResult Function(_TwoFATypeAuthenticator value)? authenticator,
    required TResult orElse(),
  }) {
    if (authenticator != null) {
      return authenticator(this);
    }
    return orElse();
  }
}

abstract class _TwoFATypeAuthenticator extends TwoFAType {
  const factory _TwoFATypeAuthenticator([final String? value]) =
      _$TwoFATypeAuthenticatorImpl;
  const _TwoFATypeAuthenticator._() : super._();

  @override
  String? get value;

  /// Create a copy of TwoFAType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TwoFATypeAuthenticatorImplCopyWith<_$TwoFATypeAuthenticatorImpl>
      get copyWith => throw _privateConstructorUsedError;
}
