// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_action_challenge.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActionChallenge _$UserActionChallengeFromJson(Map<String, dynamic> json) =>
    UserActionChallenge(
      json['attestation'] as String,
      json['userVerification'] as String,
      json['externalAuthenticationUrl'] as String,
      json['challenge'] as String,
      json['challengeIdentifier'] as String,
      RelyingParty.fromJson(json['rp'] as Map<String, dynamic>),
      (json['supportedCredentialKinds'] as List<dynamic>)
          .map((e) =>
              SupportedCredentialKinds2.fromJson(e as Map<String, dynamic>))
          .toList(),
      AllowCredentials.fromJson(
          json['allowCredentials'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserActionChallengeToJson(
        UserActionChallenge instance) =>
    <String, dynamic>{
      'attestation': instance.attestation,
      'userVerification': instance.userVerification,
      'externalAuthenticationUrl': instance.externalAuthenticationUrl,
      'challenge': instance.challenge,
      'challengeIdentifier': instance.challengeIdentifier,
      'rp': instance.rp.toJson(),
      'supportedCredentialKinds':
          instance.supportedCredentialKinds.map((e) => e.toJson()).toList(),
      'allowCredentials': instance.allowCredentials.toJson(),
    };
