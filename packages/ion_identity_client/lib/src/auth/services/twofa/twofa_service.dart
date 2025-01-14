// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/extract_user_id/extract_user_id_service.dart';
import 'package:ion_identity_client/src/auth/services/twofa/data_sources/twofa_data_source.dart';
import 'package:ion_identity_client/src/core/network/network_exception.dart';
import 'package:ion_identity_client/src/wallets/ion_identity_wallets.dart';

class TwoFAService {
  const TwoFAService({
    required this.username,
    required TwoFADataSource dataSource,
    required IONIdentityWallets wallets,
    required ExtractUserIdService extractUserIdService,
  })  : _dataSource = dataSource,
        _wallets = wallets,
        _extractUserIdService = extractUserIdService;

  final String username;
  final TwoFADataSource _dataSource;
  final IONIdentityWallets _wallets;
  final ExtractUserIdService _extractUserIdService;

  Future<String?> requestTwoFACode({
    required TwoFAType twoFAType,
    required OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
    required Map<String, String>? verificationCodes,
    String? recoveryIdentityKeyName,
  }) async {
    if (recoveryIdentityKeyName != null) {
      await _dataSource.requestTwoFACode(
        username: recoveryIdentityKeyName,
        userId: recoveryIdentityKeyName,
        twoFAOption: twoFAType.option,
      );
      return null;
    }

    final userId = _extractUserIdService.extractUserId(username: username);
    final base64Signature = await _generateSignature(userId, onVerifyIdentity);

    final response = await _dataSource.requestTwoFACode(
      signature: base64Signature,
      username: username,
      userId: userId,
      twoFAOption: twoFAType.option,
      verificationCodes: verificationCodes,
      email: twoFAType.emailOrNull,
      phoneNumber: twoFAType.phoneNumberOrNull,
    );

    return _extractCodeFromResponse(response);
  }

  Future<void> verifyTwoFA(TwoFAType twoFAType) async {
    final userId = _extractUserIdService.extractUserId(username: username);

    try {
      await _dataSource.verifyTwoFA(
        username: username,
        userId: userId,
        twoFAOption: twoFAType.option,
        code: twoFAType.value!,
      );
    } on RequestExecutionException catch (e) {
      final exception = _mapException(e);
      throw exception;
    }
  }

  Future<void> deleteTwoFA(
    TwoFAType twoFAType,
    OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity, [
    List<TwoFAType> verificationCodes = const [],
  ]) async {
    final userId = _extractUserIdService.extractUserId(username: username);
    final base64Signature = await _generateSignature(userId, onVerifyIdentity);

    try {
      await _dataSource.deleteTwoFA(
        signature: base64Signature,
        username: username,
        userId: userId,
        twoFAType: twoFAType,
        verificationCodes: verificationCodes,
      );
    } on RequestExecutionException catch (e) {
      final exception = _mapException(e);
      throw exception;
    }
  }

  Future<String> _generateSignature(
    String userId,
    OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
  ) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final mainWallet = (await _wallets.getWallets()).first;

    final hash = sha256.convert(utf8.encode('$timestamp:$userId'));

    final signatureResponse = await onVerifyIdentity(
      onPasswordFlow: ({required String password}) {
        return _wallets.generateHashSignatureWithPassword(
          mainWallet.id,
          hash.toString(),
          password,
        );
      },
      onPasskeyFlow: () {
        return _wallets.generateHashSignatureWithPasskey(
          mainWallet.id,
          hash.toString(),
        );
      },
      onBiometricsFlow: ({required String localisedReason}) {
        return _wallets.generateHashSignatureWithBiometrics(
          mainWallet.id,
          hash.toString(),
          localisedReason,
        );
      },
    );

    final signature = signatureResponse.signature['encoded'].toString().substring(2);

    final base64Signature = base64Encode(utf8.encode('$signature:$timestamp:$userId'));

    return base64Signature;
  }

  String? _extractCodeFromResponse(Map<String, dynamic> response) {
    if (response.isEmpty) {
      return null;
    }

    final url = response['TOTPAuthenticatorURL'] as String?;
    if (url == null) {
      return null;
    }

    return Uri.parse(url).queryParameters['secret'];
  }

  Exception _mapException(RequestExecutionException e) {
    if (e.error is! DioException) return e;

    final exception = e.error as DioException;
    if (InvalidTwoFaCodeException.isMatch(exception)) {
      return InvalidTwoFaCodeException();
    }

    return e;
  }
}
