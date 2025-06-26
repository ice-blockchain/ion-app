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
    );

Map<String, dynamic> _$$SignedChallengeImplToJson(
        _$SignedChallengeImpl instance) =>
    <String, dynamic>{
      'firstFactorCredential': instance.firstFactorCredential.toJson(),
    };
