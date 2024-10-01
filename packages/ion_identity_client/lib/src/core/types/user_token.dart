// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ion_identity_client/src/core/types/types.dart';

@immutable
class UserToken {
  const UserToken({
    required this.username,
    required this.token,
  });

  factory UserToken.fromJson(JsonObject map) {
    return UserToken(
      username: map['username'] as String,
      token: map['token'] as String,
    );
  }

  factory UserToken.fromJsonString(String source) =>
      UserToken.fromJson(json.decode(source) as JsonObject);

  final String username;
  final String token;

  UserToken copyWith({
    String? username,
    String? token,
  }) {
    return UserToken(
      username: username ?? this.username,
      token: token ?? this.token,
    );
  }

  JsonObject toJson() {
    return {
      'username': username,
      'token': token,
    };
  }

  String toJsonString() => json.encode(toJson());

  @override
  String toString() => 'UserToken(username: $username, token: $token)';

  @override
  bool operator ==(covariant UserToken other) {
    if (identical(this, other)) return true;

    return other.username == username && other.token == token;
  }

  @override
  int get hashCode => username.hashCode ^ token.hashCode;
}
