// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'init_twofa_request.c.dart';

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
    _$InitTwoFARequestImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('2FAVerificationCodes', instance.verificationCodes);
  writeNotNull('email', instance.email);
  writeNotNull('phoneNumber', instance.phoneNumber);
  writeNotNull('replace', instance.replace);
  return val;
}
