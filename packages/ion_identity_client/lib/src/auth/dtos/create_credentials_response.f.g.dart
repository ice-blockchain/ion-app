// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_credentials_response.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateCredentialsResponseImpl _$$CreateCredentialsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateCredentialsResponseImpl(
      kind: json['kind'] as String,
      challengeIdentifier: json['challengeIdentifier'] as String,
      challenge: json['challenge'] as String,
      rp: RelyingParty.fromJson(json['rp'] as Map<String, dynamic>),
      user: UserInformation.fromJson(json['user'] as Map<String, dynamic>),
      pubKeyCredParams: (json['pubKeyCredParams'] as List<dynamic>)
          .map((e) =>
              PublicKeyCredentialParameters.fromJson(e as Map<String, dynamic>))
          .toList(),
      attestation: json['attestation'] as String,
      excludeCredentials: (json['excludeCredentials'] as List<dynamic>?)
          ?.map((e) =>
              PublicKeyCredentialDescriptor.fromJson(e as Map<String, dynamic>))
          .toList(),
      authenticatorSelection: json['authenticatorSelection'] == null
          ? null
          : AuthenticatorSelectionCriteria.fromJson(
              json['authenticatorSelection'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CreateCredentialsResponseImplToJson(
        _$CreateCredentialsResponseImpl instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'challengeIdentifier': instance.challengeIdentifier,
      'challenge': instance.challenge,
      'rp': instance.rp.toJson(),
      'user': instance.user.toJson(),
      'pubKeyCredParams':
          instance.pubKeyCredParams.map((e) => e.toJson()).toList(),
      'attestation': instance.attestation,
      if (instance.excludeCredentials?.map((e) => e.toJson()).toList()
          case final value?)
        'excludeCredentials': value,
      if (instance.authenticatorSelection?.toJson() case final value?)
        'authenticatorSelection': value,
    };
