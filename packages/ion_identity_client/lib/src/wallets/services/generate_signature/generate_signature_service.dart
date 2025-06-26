// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:ion_identity_client/src/wallets/services/generate_signature/data_sources/generate_signature_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/generate_signature/models/generate_signature_response.f.dart';

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

  Future<GenerateSignatureResponse> generateHashSignatureWithPasskey({
    required String walletId,
    required String hash,
    String? externalId,
  }) async {
    return _generateSignature(
      walletId: walletId,
      hash: hash,
      externalId: externalId,
      signFn: (request) => _userActionSigner.signWithPasskey(
        request,
        GenerateSignatureResponse.fromJson,
      ),
    );
  }

  Future<GenerateSignatureResponse> generateHashSignatureWithPassword({
    required String walletId,
    required String hash,
    required String password,
    String? externalId,
  }) async {
    return _generateSignature(
      walletId: walletId,
      hash: hash,
      externalId: externalId,
      signFn: (request) => _userActionSigner.signWithPassword(
        request,
        GenerateSignatureResponse.fromJson,
        password,
      ),
    );
  }

  Future<GenerateSignatureResponse> generateHashSignatureWithBiometrics({
    required String walletId,
    required String hash,
    required String localisedReason,
    required String localisedCancel,
    String? externalId,
  }) async {
    return _generateSignature(
      walletId: walletId,
      hash: hash,
      externalId: externalId,
      signFn: (request) => _userActionSigner.signWithBiometrics(
        request,
        GenerateSignatureResponse.fromJson,
        localisedReason,
        localisedCancel,
      ),
    );
  }

  Future<GenerateSignatureResponse> generateMessageSignatureWithPasskey({
    required String walletId,
    required String message,
    String? externalId,
  }) async {
    return _generateSignature(
      walletId: walletId,
      message: message,
      externalId: externalId,
      signFn: (request) => _userActionSigner.signWithPasskey(
        request,
        GenerateSignatureResponse.fromJson,
      ),
    );
  }

  Future<GenerateSignatureResponse> generateMessageSignatureWithPassword({
    required String walletId,
    required String message,
    required String password,
    String? externalId,
  }) async {
    return _generateSignature(
      walletId: walletId,
      message: message,
      externalId: externalId,
      signFn: (request) => _userActionSigner.signWithPassword(
        request,
        GenerateSignatureResponse.fromJson,
        password,
      ),
    );
  }

  Future<GenerateSignatureResponse> _generateSignature({
    required String walletId,
    required Future<GenerateSignatureResponse> Function(UserActionSigningRequest) signFn,
    String? hash,
    String? message,
    String? externalId,
  }) async {
    final request = _dataSource.buildGenerateSignatureSigningRequest(
      username: username,
      walletId: walletId,
      message: message,
      hash: hash,
      externalId: externalId,
    );

    return signFn(request);
  }
}
