// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_registration_challenge.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistrationChallenge _$UserRegistrationChallengeFromJson(
        Map<String, dynamic> json) =>
    UserRegistrationChallenge(
      json['temporaryAuthenticationToken'] as String?,
      RelyingParty.fromJson(json['rp'] as Map<String, dynamic>),
      UserInformation.fromJson(json['user'] as Map<String, dynamic>),
      json['supportedCredentialKinds'] == null
          ? null
          : SupportedCredentialKinds.fromJson(
              json['supportedCredentialKinds'] as Map<String, dynamic>),
      json['otpUrl'] as String?,
      json['challenge'] as String,
      json['authenticatorSelection'] == null
          ? null
          : AuthenticatorSelectionCriteria.fromJson(
              json['authenticatorSelection'] as Map<String, dynamic>),
      json['attestation'] as String,
      (json['pubKeyCredParams'] as List<dynamic>)
          .map((e) =>
              PublicKeyCredentialParameters.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['excludeCredentials'] as List<dynamic>)
          .map((e) =>
              PublicKeyCredentialDescriptor.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['allowedRecoveryCredentials'] as List<dynamic>?)
          ?.map((e) =>
              AllowedRecoveryCredential.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserRegistrationChallengeToJson(
        UserRegistrationChallenge instance) =>
    <String, dynamic>{
      if (instance.temporaryAuthenticationToken case final value?)
        'temporaryAuthenticationToken': value,
      'rp': instance.rp.toJson(),
      'user': instance.user.toJson(),
      if (instance.supportedCredentialKinds?.toJson() case final value?)
        'supportedCredentialKinds': value,
      if (instance.otpUrl case final value?) 'otpUrl': value,
      'challenge': instance.challenge,
      if (instance.authenticatorSelection?.toJson() case final value?)
        'authenticatorSelection': value,
      'attestation': instance.attestation,
      'pubKeyCredParams':
          instance.pubKeyCredParams.map((e) => e.toJson()).toList(),
      'excludeCredentials':
          instance.excludeCredentials.map((e) => e.toJson()).toList(),
      if (instance.allowedRecoveryCredentials?.map((e) => e.toJson()).toList()
          case final value?)
        'allowedRecoveryCredentials': value,
    };
