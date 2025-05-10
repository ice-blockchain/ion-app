// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

String extractUsernameFromToken(String token) {
  try {
    final parts = token.split('.');
    if (parts.length < 2) throw const FormatException('Failed to extract userId from token');

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final json = jsonDecode(decoded) as Map<String, dynamic>;

    return json['https://custom/username'] as String;
  } on FormatException {
    rethrow;
  } catch (_) {
    throw const FormatException('Failed to extract userId from token');
  }
}
