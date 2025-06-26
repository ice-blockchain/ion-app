// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication.f.freezed.dart';
part 'authentication.f.g.dart';

@freezed
class Authentication with _$Authentication {
  const factory Authentication({
    required String token,
    required String refreshToken,
  }) = _Authentication;

  const Authentication._();

  factory Authentication.empty() => const Authentication(token: '', refreshToken: '');

  factory Authentication.fromJson(Map<String, dynamic> json) => _$AuthenticationFromJson(json);
}
