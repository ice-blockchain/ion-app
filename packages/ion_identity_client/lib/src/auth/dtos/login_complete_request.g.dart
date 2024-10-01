// SPDX-License-Identifier: ice License 1.0

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_complete_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginCompleteRequest _$LoginCompleteRequestFromJson(
        Map<String, dynamic> json) =>
    LoginCompleteRequest(
      challengeIdentifier: json['challengeIdentifier'] as String,
      firstFactor:
          Fido2Assertion.fromJson(json['firstFactor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginCompleteRequestToJson(
        LoginCompleteRequest instance) =>
    <String, dynamic>{
      'challengeIdentifier': instance.challengeIdentifier,
      'firstFactor': instance.firstFactor,
    };
