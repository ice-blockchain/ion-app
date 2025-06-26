// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_action_signing_complete_request.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActionSigningCompleteRequest _$UserActionSigningCompleteRequestFromJson(
        Map<String, dynamic> json) =>
    UserActionSigningCompleteRequest(
      challengeIdentifier: json['challengeIdentifier'] as String,
      firstFactor: AssertionRequestData.fromJson(
          json['firstFactor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserActionSigningCompleteRequestToJson(
        UserActionSigningCompleteRequest instance) =>
    <String, dynamic>{
      'challengeIdentifier': instance.challengeIdentifier,
      'firstFactor': instance.firstFactor.toJson(),
    };
