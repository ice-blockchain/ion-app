// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticator_selection_criteria.j.dart';

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
      if (instance.authenticatorAttachment case final value?)
        'authenticatorAttachment': value,
      'residentKey': instance.residentKey,
      'requireResidentKey': instance.requireResidentKey,
      'userVerification': instance.userVerification,
    };
