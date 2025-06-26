// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signed_challenge.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SignedChallenge _$SignedChallengeFromJson(Map<String, dynamic> json) {
  return _SignedChallenge.fromJson(json);
}

/// @nodoc
mixin _$SignedChallenge {
  CredentialRequestData get firstFactorCredential =>
      throw _privateConstructorUsedError;

  /// Serializes this SignedChallenge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignedChallenge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignedChallengeCopyWith<SignedChallenge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignedChallengeCopyWith<$Res> {
  factory $SignedChallengeCopyWith(
          SignedChallenge value, $Res Function(SignedChallenge) then) =
      _$SignedChallengeCopyWithImpl<$Res, SignedChallenge>;
  @useResult
  $Res call({CredentialRequestData firstFactorCredential});
}

/// @nodoc
class _$SignedChallengeCopyWithImpl<$Res, $Val extends SignedChallenge>
    implements $SignedChallengeCopyWith<$Res> {
  _$SignedChallengeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignedChallenge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstFactorCredential = null,
  }) {
    return _then(_value.copyWith(
      firstFactorCredential: null == firstFactorCredential
          ? _value.firstFactorCredential
          : firstFactorCredential // ignore: cast_nullable_to_non_nullable
              as CredentialRequestData,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignedChallengeImplCopyWith<$Res>
    implements $SignedChallengeCopyWith<$Res> {
  factory _$$SignedChallengeImplCopyWith(_$SignedChallengeImpl value,
          $Res Function(_$SignedChallengeImpl) then) =
      __$$SignedChallengeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CredentialRequestData firstFactorCredential});
}

/// @nodoc
class __$$SignedChallengeImplCopyWithImpl<$Res>
    extends _$SignedChallengeCopyWithImpl<$Res, _$SignedChallengeImpl>
    implements _$$SignedChallengeImplCopyWith<$Res> {
  __$$SignedChallengeImplCopyWithImpl(
      _$SignedChallengeImpl _value, $Res Function(_$SignedChallengeImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignedChallenge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstFactorCredential = null,
  }) {
    return _then(_$SignedChallengeImpl(
      firstFactorCredential: null == firstFactorCredential
          ? _value.firstFactorCredential
          : firstFactorCredential // ignore: cast_nullable_to_non_nullable
              as CredentialRequestData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SignedChallengeImpl implements _SignedChallenge {
  const _$SignedChallengeImpl({required this.firstFactorCredential});

  factory _$SignedChallengeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignedChallengeImplFromJson(json);

  @override
  final CredentialRequestData firstFactorCredential;

  @override
  String toString() {
    return 'SignedChallenge(firstFactorCredential: $firstFactorCredential)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignedChallengeImpl &&
            (identical(other.firstFactorCredential, firstFactorCredential) ||
                other.firstFactorCredential == firstFactorCredential));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, firstFactorCredential);

  /// Create a copy of SignedChallenge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignedChallengeImplCopyWith<_$SignedChallengeImpl> get copyWith =>
      __$$SignedChallengeImplCopyWithImpl<_$SignedChallengeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignedChallengeImplToJson(
      this,
    );
  }
}

abstract class _SignedChallenge implements SignedChallenge {
  const factory _SignedChallenge(
          {required final CredentialRequestData firstFactorCredential}) =
      _$SignedChallengeImpl;

  factory _SignedChallenge.fromJson(Map<String, dynamic> json) =
      _$SignedChallengeImpl.fromJson;

  @override
  CredentialRequestData get firstFactorCredential;

  /// Create a copy of SignedChallenge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignedChallengeImplCopyWith<_$SignedChallengeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
