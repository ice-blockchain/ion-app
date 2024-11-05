// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:ion_identity_client/src/wallets/services/generate_signature/data_sources/generate_signature_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/generate_signature/models/generate_signature_response.dart';

class GenerateSignatureService {
  GenerateSignatureService({
    required this.username,
    required GenerateSignatureDataSource dataSource,
    required UserActionSigner userActionSigner,
  })  : _dataSource = dataSource,
        _userActionSigner = userActionSigner;

  final String username;
  final GenerateSignatureDataSource _dataSource;
  final UserActionSigner _userActionSigner;

  Future<GenerateSignatureResponse> generateHashSignature({
    required String walletId,
    required String hash,
    String? externalId,
  }) async {
    final request = _dataSource.buildGenerateSignatureSigningRequest(
      username: username,
      walletId: walletId,
      kind: 'Hash',
      hash: hash,
      externalId: externalId,
    );

    return _userActionSigner.execute(
      request,
      GenerateSignatureResponse.fromJson,
    );
  }

  Future<GenerateSignatureResponse> generateMessageSignature({
    required String walletId,
    required String message,
    String? externalId,
  }) async {
    final request = _dataSource.buildGenerateSignatureSigningRequest(
      username: username,
      walletId: walletId,
      kind: 'Message',
      message: message,
      externalId: externalId,
    );

    return _userActionSigner.execute(
      request,
      GenerateSignatureResponse.fromJson,
    );
  }
}
