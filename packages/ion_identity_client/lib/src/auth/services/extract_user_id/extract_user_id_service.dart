// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/identity_storage/identity_storage.dart';

class ExtractUserIdService {
  const ExtractUserIdService({
    required this.identityStorage,
  });

  final IdentityStorage identityStorage;

  String extractUserId({
    required String username,
  }) {
    final token = identityStorage.getToken(username: username)?.token;
    if (token == null) {
      throw const UnauthenticatedException();
    }

    return _extractUserIdFromToken(token);
  }

  String _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) throw const FormatException('Failed to extract userId from token');

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(decoded) as Map<String, dynamic>;

      return json['https://custom/app_metadata']?['userId'] as String;
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException('Failed to extract userId from token');
    }
  }
}
