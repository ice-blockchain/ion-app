// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  factory User({
    required String pubKey,
    required String name,
    required String username,
    required String avatarUrl,
  }) = _User;

  User._();
}
