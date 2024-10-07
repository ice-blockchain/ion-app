// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signed_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignedChallenge _$SignedChallengeFromJson(Map<String, dynamic> json) =>
    SignedChallenge(
      firstFactorCredential: Fido2Attestation.fromJson(
          json['firstFactorCredential'] as Map<String, dynamic>),
      wallets: (json['wallets'] as List<dynamic>?)
              ?.map((e) =>
                  RegisterCompleteWallet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          RequestDefaults.registerCompleteWallets,
    );

Map<String, dynamic> _$SignedChallengeToJson(SignedChallenge instance) =>
    <String, dynamic>{
      'firstFactorCredential': instance.firstFactorCredential.toJson(),
      'wallets': instance.wallets.map((e) => e.toJson()).toList(),
    };
