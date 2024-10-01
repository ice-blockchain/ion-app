// SPDX-License-Identifier: ice License 1.0

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticator_selection_criteria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticatorSelectionCriteria _$AuthenticatorSelectionCriteriaFromJson(
        Map<String, dynamic> json) =>
    AuthenticatorSelectionCriteria(
      json['authenticatorAttachment'] as String?,
      json['residentKey'] as String,
      json['requireResidentKey'] as bool,
      json['userVerification'] as String,
    );

Map<String, dynamic> _$AuthenticatorSelectionCriteriaToJson(
        AuthenticatorSelectionCriteria instance) =>
    <String, dynamic>{
      'authenticatorAttachment': instance.authenticatorAttachment,
      'residentKey': instance.residentKey,
      'requireResidentKey': instance.requireResidentKey,
      'userVerification': instance.userVerification,
    };
