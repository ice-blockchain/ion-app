// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/core/extensions/num.dart';

part 'user_token.f.freezed.dart';
part 'user_token.f.g.dart';

@freezed
class UserToken with _$UserToken {
  const factory UserToken({
    required String username,
    required String token,
    required String refreshToken,
  }) = _UserToken;

  const UserToken._();

  factory UserToken.fromJson(Map<String, dynamic> json) => _$UserTokenFromJson(json);

  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  DateTime get expiresAt {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid token');
    }

    final payload = json.decode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(parts[1]),
        ),
      ),
    ) as Map<String, dynamic>;

    return (payload['exp'] as int).toDateTime;
  }
}
