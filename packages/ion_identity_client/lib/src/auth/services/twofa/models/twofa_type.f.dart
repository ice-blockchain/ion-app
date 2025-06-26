// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'twofa_type.f.freezed.dart';

@freezed
class TwoFAType with _$TwoFAType {
  const TwoFAType._();

  const factory TwoFAType.email([String? value]) = _TwoFATypeEmail;
  const factory TwoFAType.sms([String? value]) = _TwoFATypeSms;
  const factory TwoFAType.authenticator([String? value]) = _TwoFATypeAuthenticator;

  String get option => map(
        email: (value) => 'email',
        sms: (value) => 'sms',
        authenticator: (value) => 'totp_authenticator',
      );

  String? get emailOrNull => mapOrNull(email: (value) => value.value);
  String? get phoneNumberOrNull => mapOrNull(sms: (value) => value.value);
}
