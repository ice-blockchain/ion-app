// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:ion_identity_client/src/wallets/services/pseudo_network_generate_signature/data_sources/pseudo_network_generate_signature_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/pseudo_network_generate_signature/models/pseudo_network_signature_response.dart';

class PseudoNetworkGenerateSignatureService {
  PseudoNetworkGenerateSignatureService({
    required this.username,
    required PseudoNetworkGenerateSignatureDataSource dataSource,
    required UserActionSigner userActionSigner,
  })  : _dataSource = dataSource,
        _userActionSigner = userActionSigner;

  final String username;
  final PseudoNetworkGenerateSignatureDataSource _dataSource;
  final UserActionSigner _userActionSigner;

  Future<PseudoNetworkSignatureResponse> generateHashSignature({
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
      PseudoNetworkSignatureResponse.fromJson,
    );
  }

  Future<PseudoNetworkSignatureResponse> generateMessageSignature({
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
      PseudoNetworkSignatureResponse.fromJson,
    );
  }
}
