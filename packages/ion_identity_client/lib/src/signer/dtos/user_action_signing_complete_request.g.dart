// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_action_signing_complete_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActionSigningCompleteRequest _$UserActionSigningCompleteRequestFromJson(
        Map<String, dynamic> json) =>
    UserActionSigningCompleteRequest(
      challengeIdentifier: json['challengeIdentifier'] as String,
      firstFactor:
          Fido2Assertion.fromJson(json['firstFactor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserActionSigningCompleteRequestToJson(
        UserActionSigningCompleteRequest instance) =>
    <String, dynamic>{
      'challengeIdentifier': instance.challengeIdentifier,
      'firstFactor': instance.firstFactor,
    };
