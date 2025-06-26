// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assertion_request_data.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AssertionRequestData _$AssertionRequestDataFromJson(Map<String, dynamic> json) {
  return _AssertionRequestData.fromJson(json);
}

/// @nodoc
mixin _$AssertionRequestData {
  CredentialKind get kind => throw _privateConstructorUsedError;
  CredentialAssertionData get credentialAssertion =>
      throw _privateConstructorUsedError;

  /// Serializes this AssertionRequestData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssertionRequestData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssertionRequestDataCopyWith<AssertionRequestData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssertionRequestDataCopyWith<$Res> {
  factory $AssertionRequestDataCopyWith(AssertionRequestData value,
          $Res Function(AssertionRequestData) then) =
      _$AssertionRequestDataCopyWithImpl<$Res, AssertionRequestData>;
  @useResult
  $Res call({CredentialKind kind, CredentialAssertionData credentialAssertion});
}

/// @nodoc
class _$AssertionRequestDataCopyWithImpl<$Res,
        $Val extends AssertionRequestData>
    implements $AssertionRequestDataCopyWith<$Res> {
  _$AssertionRequestDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssertionRequestData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? credentialAssertion = null,
  }) {
    return _then(_value.copyWith(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as CredentialKind,
      credentialAssertion: null == credentialAssertion
          ? _value.credentialAssertion
          : credentialAssertion // ignore: cast_nullable_to_non_nullable
              as CredentialAssertionData,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssertionRequestDataImplCopyWith<$Res>
    implements $AssertionRequestDataCopyWith<$Res> {
  factory _$$AssertionRequestDataImplCopyWith(_$AssertionRequestDataImpl value,
          $Res Function(_$AssertionRequestDataImpl) then) =
      __$$AssertionRequestDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CredentialKind kind, CredentialAssertionData credentialAssertion});
}

/// @nodoc
class __$$AssertionRequestDataImplCopyWithImpl<$Res>
    extends _$AssertionRequestDataCopyWithImpl<$Res, _$AssertionRequestDataImpl>
    implements _$$AssertionRequestDataImplCopyWith<$Res> {
  __$$AssertionRequestDataImplCopyWithImpl(_$AssertionRequestDataImpl _value,
      $Res Function(_$AssertionRequestDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AssertionRequestData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? credentialAssertion = null,
  }) {
    return _then(_$AssertionRequestDataImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as CredentialKind,
      credentialAssertion: null == credentialAssertion
          ? _value.credentialAssertion
          : credentialAssertion // ignore: cast_nullable_to_non_nullable
              as CredentialAssertionData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssertionRequestDataImpl implements _AssertionRequestData {
  const _$AssertionRequestDataImpl(
      {required this.kind, required this.credentialAssertion});

  factory _$AssertionRequestDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssertionRequestDataImplFromJson(json);

  @override
  final CredentialKind kind;
  @override
  final CredentialAssertionData credentialAssertion;

  @override
  String toString() {
    return 'AssertionRequestData(kind: $kind, credentialAssertion: $credentialAssertion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssertionRequestDataImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.credentialAssertion, credentialAssertion) ||
                other.credentialAssertion == credentialAssertion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, credentialAssertion);

  /// Create a copy of AssertionRequestData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssertionRequestDataImplCopyWith<_$AssertionRequestDataImpl>
      get copyWith =>
          __$$AssertionRequestDataImplCopyWithImpl<_$AssertionRequestDataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssertionRequestDataImplToJson(
      this,
    );
  }
}

abstract class _AssertionRequestData implements AssertionRequestData {
  const factory _AssertionRequestData(
          {required final CredentialKind kind,
          required final CredentialAssertionData credentialAssertion}) =
      _$AssertionRequestDataImpl;

  factory _AssertionRequestData.fromJson(Map<String, dynamic> json) =
      _$AssertionRequestDataImpl.fromJson;

  @override
  CredentialKind get kind;
  @override
  CredentialAssertionData get credentialAssertion;

  /// Create a copy of AssertionRequestData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssertionRequestDataImplCopyWith<_$AssertionRequestDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
