// SPDX-License-Identifier: ice License 1.0

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialChallenge _$CredentialChallengeFromJson(Map<String, dynamic> json) =>
    CredentialChallenge(
      challenge: json['challenge'] as String,
      challengeIdentifier: json['challengeIdentifier'] as String,
    );

Map<String, dynamic> _$CredentialChallengeToJson(
        CredentialChallenge instance) =>
    <String, dynamic>{
      'challenge': instance.challenge,
      'challengeIdentifier': instance.challengeIdentifier,
    };
