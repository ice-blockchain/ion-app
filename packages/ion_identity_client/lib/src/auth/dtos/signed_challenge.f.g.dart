// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signed_challenge.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignedChallengeImpl _$$SignedChallengeImplFromJson(
        Map<String, dynamic> json) =>
    _$SignedChallengeImpl(
      firstFactorCredential: CredentialRequestData.fromJson(
          json['firstFactorCredential'] as Map<String, dynamic>),
      earlyAccessEmail: json['earlyAccessEmail'] as String?,
    );

Map<String, dynamic> _$$SignedChallengeImplToJson(
        _$SignedChallengeImpl instance) =>
    <String, dynamic>{
      'firstFactorCredential': instance.firstFactorCredential.toJson(),
      if (instance.earlyAccessEmail case final value?)
        'earlyAccessEmail': value,
    };
