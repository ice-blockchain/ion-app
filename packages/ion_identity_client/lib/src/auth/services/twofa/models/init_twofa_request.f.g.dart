// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'init_twofa_request.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InitTwoFARequestImpl _$$InitTwoFARequestImplFromJson(
        Map<String, dynamic> json) =>
    _$InitTwoFARequestImpl(
      verificationCodes:
          (json['2FAVerificationCodes'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      replace: json['replace'] as String?,
    );

Map<String, dynamic> _$$InitTwoFARequestImplToJson(
        _$InitTwoFARequestImpl instance) =>
    <String, dynamic>{
      if (instance.verificationCodes case final value?)
        '2FAVerificationCodes': value,
      if (instance.email case final value?) 'email': value,
      if (instance.phoneNumber case final value?) 'phoneNumber': value,
      if (instance.replace case final value?) 'replace': value,
    };
