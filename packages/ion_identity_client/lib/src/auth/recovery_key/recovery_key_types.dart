import 'package:cryptography/cryptography.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recovery_key_types.g.dart';

class RecoveryKeyData {
  const RecoveryKeyData({
    required this.credentialInfo,
    required this.encryptedPrivateKey,
    required this.recoveryCode,
    required this.name,
  });

  final CredentialInfo credentialInfo;
  final String encryptedPrivateKey;
  final String recoveryCode;
  final String name;
}

@JsonSerializable()
class CredentialInfo {
  const CredentialInfo({
    required this.credId,
    required this.clientData,
    required this.attestationData,
  });

  factory CredentialInfo.fromJson(JsonObject json) => _$CredentialInfoFromJson(json);

  final String credId;
  final String clientData;
  final String attestationData;

  JsonObject toJson() => _$CredentialInfoToJson(this);
}

@JsonSerializable()
class CredentialRequestData {
  const CredentialRequestData({
    required this.challengeIdentifier,
    required this.credentialName,
    required this.credentialKind,
    required this.credentialInfo,
    required this.encryptedPrivateKey,
  });

  factory CredentialRequestData.fromJson(JsonObject json) => _$CredentialRequestDataFromJson(json);

  final String challengeIdentifier;
  final String credentialName;
  final String credentialKind;
  final CredentialInfo credentialInfo;
  final String encryptedPrivateKey;

  JsonObject toJson() => _$CredentialRequestDataToJson(this);
}

class KeyPairData {
  KeyPairData({
    required this.keyPair,
    required this.publicKey,
    required this.publicKeyPem,
    required this.privateKeyPem,
    required this.privateKeyBytes,
  });

  final SimpleKeyPairData keyPair;
  final SimplePublicKey publicKey;
  final String publicKeyPem;
  final String privateKeyPem;
  final List<int> privateKeyBytes;
}

abstract class RecoveryKeyResult {
  const RecoveryKeyResult();
}

class RecoveryKeySuccess extends RecoveryKeyResult {
  const RecoveryKeySuccess({
    required this.recoveryName,
    required this.recoveryId,
    required this.recoveryCode,
  });

  final String recoveryName;
  final String recoveryId;
  final String recoveryCode;
}

class RecoveryKeyFailure extends RecoveryKeyResult {
  const RecoveryKeyFailure(this.error);

  final String error;
}

@JsonSerializable()
class CredentialChallenge {
  CredentialChallenge({
    required this.challenge,
    required this.challengeIdentifier,
  });

  factory CredentialChallenge.fromJson(JsonObject json) => _$CredentialChallengeFromJson(json);

  final String challenge;
  final String challengeIdentifier;
}

@JsonSerializable()
class CredentialResponse {
  const CredentialResponse({
    required this.credentialUuid,
    required this.credentialId,
    required this.dateCreated,
    required this.isActive,
    required this.kind,
    required this.name,
    required this.origin,
    required this.relyingPartyId,
    required this.publicKey,
  });

  factory CredentialResponse.fromJson(JsonObject json) => _$CredentialResponseFromJson(json);

  final String credentialUuid;
  final String credentialId;
  final DateTime dateCreated;
  final bool isActive;
  final String kind;
  final String name;
  final String origin;
  final String relyingPartyId;
  final String publicKey;
}
