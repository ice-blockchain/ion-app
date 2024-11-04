// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';

class ExtractUserIdService {
  const ExtractUserIdService({
    required this.tokenStorage,
  });

  final TokenStorage tokenStorage;

  String? extractUserId({
    required String username,
  }) {
    final token = tokenStorage.getToken(username: username)?.token;
    if (token == null) {
      throw const UnauthenticatedException();
    }

    return _extractUserIdFromToken(token);
  }

  String? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(decoded) as Map<String, dynamic>;

      return json['https://custom/app_metadata']?['userId'] as String?;
    } catch (_) {
      return null;
    }
  }
}
