// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_credentials_response.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateCredentialsResponse _$CreateCredentialsResponseFromJson(
    Map<String, dynamic> json) {
  return _CreateCredentialsResponse.fromJson(json);
}

/// @nodoc
mixin _$CreateCredentialsResponse {
  String get kind => throw _privateConstructorUsedError;
  String get challengeIdentifier => throw _privateConstructorUsedError;
  String get challenge => throw _privateConstructorUsedError;
  RelyingParty get rp => throw _privateConstructorUsedError;
  UserInformation get user => throw _privateConstructorUsedError;
  List<PublicKeyCredentialParameters> get pubKeyCredParams =>
      throw _privateConstructorUsedError;
  String get attestation => throw _privateConstructorUsedError;
  List<PublicKeyCredentialDescriptor>? get excludeCredentials =>
      throw _privateConstructorUsedError;
  AuthenticatorSelectionCriteria? get authenticatorSelection =>
      throw _privateConstructorUsedError;

  /// Serializes this CreateCredentialsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateCredentialsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateCredentialsResponseCopyWith<CreateCredentialsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCredentialsResponseCopyWith<$Res> {
  factory $CreateCredentialsResponseCopyWith(CreateCredentialsResponse value,
          $Res Function(CreateCredentialsResponse) then) =
      _$CreateCredentialsResponseCopyWithImpl<$Res, CreateCredentialsResponse>;
  @useResult
  $Res call(
      {String kind,
      String challengeIdentifier,
      String challenge,
      RelyingParty rp,
      UserInformation user,
      List<PublicKeyCredentialParameters> pubKeyCredParams,
      String attestation,
      List<PublicKeyCredentialDescriptor>? excludeCredentials,
      AuthenticatorSelectionCriteria? authenticatorSelection});
}

/// @nodoc
class _$CreateCredentialsResponseCopyWithImpl<$Res,
        $Val extends CreateCredentialsResponse>
    implements $CreateCredentialsResponseCopyWith<$Res> {
  _$CreateCredentialsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateCredentialsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? challengeIdentifier = null,
    Object? challenge = null,
    Object? rp = null,
    Object? user = null,
    Object? pubKeyCredParams = null,
    Object? attestation = null,
    Object? excludeCredentials = freezed,
    Object? authenticatorSelection = freezed,
  }) {
    return _then(_value.copyWith(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      challengeIdentifier: null == challengeIdentifier
          ? _value.challengeIdentifier
          : challengeIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      challenge: null == challenge
          ? _value.challenge
          : challenge // ignore: cast_nullable_to_non_nullable
              as String,
      rp: null == rp
          ? _value.rp
          : rp // ignore: cast_nullable_to_non_nullable
              as RelyingParty,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserInformation,
      pubKeyCredParams: null == pubKeyCredParams
          ? _value.pubKeyCredParams
          : pubKeyCredParams // ignore: cast_nullable_to_non_nullable
              as List<PublicKeyCredentialParameters>,
      attestation: null == attestation
          ? _value.attestation
          : attestation // ignore: cast_nullable_to_non_nullable
              as String,
      excludeCredentials: freezed == excludeCredentials
          ? _value.excludeCredentials
          : excludeCredentials // ignore: cast_nullable_to_non_nullable
              as List<PublicKeyCredentialDescriptor>?,
      authenticatorSelection: freezed == authenticatorSelection
          ? _value.authenticatorSelection
          : authenticatorSelection // ignore: cast_nullable_to_non_nullable
              as AuthenticatorSelectionCriteria?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateCredentialsResponseImplCopyWith<$Res>
    implements $CreateCredentialsResponseCopyWith<$Res> {
  factory _$$CreateCredentialsResponseImplCopyWith(
          _$CreateCredentialsResponseImpl value,
          $Res Function(_$CreateCredentialsResponseImpl) then) =
      __$$CreateCredentialsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String kind,
      String challengeIdentifier,
      String challenge,
      RelyingParty rp,
      UserInformation user,
      List<PublicKeyCredentialParameters> pubKeyCredParams,
      String attestation,
      List<PublicKeyCredentialDescriptor>? excludeCredentials,
      AuthenticatorSelectionCriteria? authenticatorSelection});
}

/// @nodoc
class __$$CreateCredentialsResponseImplCopyWithImpl<$Res>
    extends _$CreateCredentialsResponseCopyWithImpl<$Res,
        _$CreateCredentialsResponseImpl>
    implements _$$CreateCredentialsResponseImplCopyWith<$Res> {
  __$$CreateCredentialsResponseImplCopyWithImpl(
      _$CreateCredentialsResponseImpl _value,
      $Res Function(_$CreateCredentialsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateCredentialsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? challengeIdentifier = null,
    Object? challenge = null,
    Object? rp = null,
    Object? user = null,
    Object? pubKeyCredParams = null,
    Object? attestation = null,
    Object? excludeCredentials = freezed,
    Object? authenticatorSelection = freezed,
  }) {
    return _then(_$CreateCredentialsResponseImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      challengeIdentifier: null == challengeIdentifier
          ? _value.challengeIdentifier
          : challengeIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      challenge: null == challenge
          ? _value.challenge
          : challenge // ignore: cast_nullable_to_non_nullable
              as String,
      rp: null == rp
          ? _value.rp
          : rp // ignore: cast_nullable_to_non_nullable
              as RelyingParty,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserInformation,
      pubKeyCredParams: null == pubKeyCredParams
          ? _value._pubKeyCredParams
          : pubKeyCredParams // ignore: cast_nullable_to_non_nullable
              as List<PublicKeyCredentialParameters>,
      attestation: null == attestation
          ? _value.attestation
          : attestation // ignore: cast_nullable_to_non_nullable
              as String,
      excludeCredentials: freezed == excludeCredentials
          ? _value._excludeCredentials
          : excludeCredentials // ignore: cast_nullable_to_non_nullable
              as List<PublicKeyCredentialDescriptor>?,
      authenticatorSelection: freezed == authenticatorSelection
          ? _value.authenticatorSelection
          : authenticatorSelection // ignore: cast_nullable_to_non_nullable
              as AuthenticatorSelectionCriteria?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateCredentialsResponseImpl implements _CreateCredentialsResponse {
  _$CreateCredentialsResponseImpl(
      {required this.kind,
      required this.challengeIdentifier,
      required this.challenge,
      required this.rp,
      required this.user,
      required final List<PublicKeyCredentialParameters> pubKeyCredParams,
      required this.attestation,
      final List<PublicKeyCredentialDescriptor>? excludeCredentials,
      this.authenticatorSelection})
      : _pubKeyCredParams = pubKeyCredParams,
        _excludeCredentials = excludeCredentials;

  factory _$CreateCredentialsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateCredentialsResponseImplFromJson(json);

  @override
  final String kind;
  @override
  final String challengeIdentifier;
  @override
  final String challenge;
  @override
  final RelyingParty rp;
  @override
  final UserInformation user;
  final List<PublicKeyCredentialParameters> _pubKeyCredParams;
  @override
  List<PublicKeyCredentialParameters> get pubKeyCredParams {
    if (_pubKeyCredParams is EqualUnmodifiableListView)
      return _pubKeyCredParams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pubKeyCredParams);
  }

  @override
  final String attestation;
  final List<PublicKeyCredentialDescriptor>? _excludeCredentials;
  @override
  List<PublicKeyCredentialDescriptor>? get excludeCredentials {
    final value = _excludeCredentials;
    if (value == null) return null;
    if (_excludeCredentials is EqualUnmodifiableListView)
      return _excludeCredentials;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final AuthenticatorSelectionCriteria? authenticatorSelection;

  @override
  String toString() {
    return 'CreateCredentialsResponse(kind: $kind, challengeIdentifier: $challengeIdentifier, challenge: $challenge, rp: $rp, user: $user, pubKeyCredParams: $pubKeyCredParams, attestation: $attestation, excludeCredentials: $excludeCredentials, authenticatorSelection: $authenticatorSelection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateCredentialsResponseImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.challengeIdentifier, challengeIdentifier) ||
                other.challengeIdentifier == challengeIdentifier) &&
            (identical(other.challenge, challenge) ||
                other.challenge == challenge) &&
            (identical(other.rp, rp) || other.rp == rp) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality()
                .equals(other._pubKeyCredParams, _pubKeyCredParams) &&
            (identical(other.attestation, attestation) ||
                other.attestation == attestation) &&
            const DeepCollectionEquality()
                .equals(other._excludeCredentials, _excludeCredentials) &&
            (identical(other.authenticatorSelection, authenticatorSelection) ||
                other.authenticatorSelection == authenticatorSelection));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      kind,
      challengeIdentifier,
      challenge,
      rp,
      user,
      const DeepCollectionEquality().hash(_pubKeyCredParams),
      attestation,
      const DeepCollectionEquality().hash(_excludeCredentials),
      authenticatorSelection);

  /// Create a copy of CreateCredentialsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateCredentialsResponseImplCopyWith<_$CreateCredentialsResponseImpl>
      get copyWith => __$$CreateCredentialsResponseImplCopyWithImpl<
          _$CreateCredentialsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateCredentialsResponseImplToJson(
      this,
    );
  }
}

abstract class _CreateCredentialsResponse implements CreateCredentialsResponse {
  factory _CreateCredentialsResponse(
          {required final String kind,
          required final String challengeIdentifier,
          required final String challenge,
          required final RelyingParty rp,
          required final UserInformation user,
          required final List<PublicKeyCredentialParameters> pubKeyCredParams,
          required final String attestation,
          final List<PublicKeyCredentialDescriptor>? excludeCredentials,
          final AuthenticatorSelectionCriteria? authenticatorSelection}) =
      _$CreateCredentialsResponseImpl;

  factory _CreateCredentialsResponse.fromJson(Map<String, dynamic> json) =
      _$CreateCredentialsResponseImpl.fromJson;

  @override
  String get kind;
  @override
  String get challengeIdentifier;
  @override
  String get challenge;
  @override
  RelyingParty get rp;
  @override
  UserInformation get user;
  @override
  List<PublicKeyCredentialParameters> get pubKeyCredParams;
  @override
  String get attestation;
  @override
  List<PublicKeyCredentialDescriptor>? get excludeCredentials;
  @override
  AuthenticatorSelectionCriteria? get authenticatorSelection;

  /// Create a copy of CreateCredentialsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateCredentialsResponseImplCopyWith<_$CreateCredentialsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
