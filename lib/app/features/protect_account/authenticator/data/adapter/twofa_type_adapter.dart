// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion_identity_client/ion_identity.dart';

class TwoFaTypeAdapter {
  TwoFaTypeAdapter(
    this._twoFaType, [
    this._value,
  ]);

  final TwoFaType _twoFaType;
  final String? _value;

  TwoFAType get twoFAType => switch (_twoFaType) {
        TwoFaType.email => TwoFAType.email(_value),
        TwoFaType.sms => TwoFAType.sms(_value),
        TwoFaType.auth => TwoFAType.authenticator(_value),
      };
}
