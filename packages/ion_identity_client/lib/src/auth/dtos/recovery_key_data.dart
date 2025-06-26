// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/dtos/credential_info.j.dart';

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
