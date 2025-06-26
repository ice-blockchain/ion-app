// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assertion_request_data.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssertionRequestDataImpl _$$AssertionRequestDataImplFromJson(
        Map<String, dynamic> json) =>
    _$AssertionRequestDataImpl(
      kind: $enumDecode(_$CredentialKindEnumMap, json['kind']),
      credentialAssertion: CredentialAssertionData.fromJson(
          json['credentialAssertion'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AssertionRequestDataImplToJson(
        _$AssertionRequestDataImpl instance) =>
    <String, dynamic>{
      'kind': _$CredentialKindEnumMap[instance.kind]!,
      'credentialAssertion': instance.credentialAssertion.toJson(),
    };

const _$CredentialKindEnumMap = {
  CredentialKind.Fido2: 'Fido2',
  CredentialKind.Key: 'Key',
  CredentialKind.PasswordProtectedKey: 'PasswordProtectedKey',
  CredentialKind.RecoveryKey: 'RecoveryKey',
};
