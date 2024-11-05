// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion_identity_client/src/core/types/http_method.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';
import 'package:ion_identity_client/src/wallets/services/generate_signature/models/generate_signature_request.dart';

class GenerateSignatureDataSource {
  const GenerateSignatureDataSource();

  static const generateSignaturePath = '/wallets/%s/signatures';

  UserActionSigningRequest buildGenerateSignatureSigningRequest({
    required String username,
    required String walletId,
    required String kind,
    String? hash,
    String? message,
    String? externalId,
  }) {
    final request = kind == 'Hash'
        ? SignatureRequestHash(
            kind: kind,
            hash: hash!,
            externalId: externalId,
          ).toJson()
        : SignatureRequestMessage(
            kind: kind,
            message: _hexEncode(message!),
            externalId: externalId,
          ).toJson();

    return UserActionSigningRequest(
      username: username,
      method: HttpMethod.post,
      path: generateSignaturePath.replaceFirst('%s', walletId),
      body: request,
    );
  }

  String _hexEncode(String input) {
    final bytes = utf8.encode(input);
    final hexString = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

    return hexString;
  }
}
