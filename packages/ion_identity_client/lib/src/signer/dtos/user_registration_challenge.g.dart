// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_registration_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistrationChallenge _$UserRegistrationChallengeFromJson(
        Map<String, dynamic> json) =>
    UserRegistrationChallenge(
      json['temporaryAuthenticationToken'] as String,
      RelyingParty.fromJson(json['rp'] as Map<String, dynamic>),
      UserInformation.fromJson(json['user'] as Map<String, dynamic>),
      SupportedCredentialKinds.fromJson(
          json['supportedCredentialKinds'] as Map<String, dynamic>),
      json['otpUrl'] as String?,
      json['challenge'] as String,
      AuthenticatorSelectionCriteria.fromJson(
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
      'temporaryAuthenticationToken': instance.temporaryAuthenticationToken,
      'rp': instance.rp,
      'user': instance.user,
      'supportedCredentialKinds': instance.supportedCredentialKinds,
      'otpUrl': instance.otpUrl,
      'challenge': instance.challenge,
      'authenticatorSelection': instance.authenticatorSelection,
      'attestation': instance.attestation,
      'pubKeyCredParams': instance.pubKeyCredParams,
      'excludeCredentials': instance.excludeCredentials,
      'allowedRecoveryCredentials': instance.allowedRecoveryCredentials,
    };
