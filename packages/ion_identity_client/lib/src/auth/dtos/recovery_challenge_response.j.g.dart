// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_challenge_response.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryChallengeResponse _$RecoveryChallengeResponseFromJson(
        Map<String, dynamic> json) =>
    RecoveryChallengeResponse(
      temporaryAuthenticationToken:
          json['temporaryAuthenticationToken'] as String,
      challenge: json['challenge'] as String,
      allowedRecoveryCredentials:
          (json['allowedRecoveryCredentials'] as List<dynamic>)
              .map((e) =>
                  AllowedRecoveryCredential.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$RecoveryChallengeResponseToJson(
        RecoveryChallengeResponse instance) =>
    <String, dynamic>{
      'temporaryAuthenticationToken': instance.temporaryAuthenticationToken,
      'challenge': instance.challenge,
      'allowedRecoveryCredentials':
          instance.allowedRecoveryCredentials.map((e) => e.toJson()).toList(),
    };

AllowedRecoveryCredential _$AllowedRecoveryCredentialFromJson(
        Map<String, dynamic> json) =>
    AllowedRecoveryCredential(
      id: json['id'] as String,
      encryptedRecoveryKey: json['encryptedRecoveryKey'] as String,
    );

Map<String, dynamic> _$AllowedRecoveryCredentialToJson(
        AllowedRecoveryCredential instance) =>
    <String, dynamic>{
      'id': instance.id,
      'encryptedRecoveryKey': instance.encryptedRecoveryKey,
    };
