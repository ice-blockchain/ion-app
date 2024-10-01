// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_methods.freezed.dart';

@Freezed(copyWith: true)
class SecurityMethods with _$SecurityMethods {
  const factory SecurityMethods({
    @Default(false) bool isBackupEnabled,
    @Default(false) bool isEmailEnabled,
    @Default(false) bool isAuthenticatorEnabled,
    @Default(false) bool isPhoneEnabled,
  }) = _SecurityMethods;
}
