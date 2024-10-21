// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication.freezed.dart';
part 'authentication.g.dart';

@freezed
class Authentication with _$Authentication {
  factory Authentication({
    required String token,
    required String refreshToken,
  }) = _Authentication;

  factory Authentication.fromJson(Map<String, dynamic> json) => _$AuthenticationFromJson(json);
}
