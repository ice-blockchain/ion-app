// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/utils/formatters.dart';

import '../test_utils.dart';

void main() {
  parameterizedGroup('obscureEmail', [
    (email: 'johndoe@example.com', expected: '*****oe@example.com'),
    (email: 'joe@example.com', expected: '*****oe@example.com'),
    (email: 'jane@example.com', expected: '*****ne@example.com'),
    (email: 'a@example.com', expected: '*****a@example.com'),
    (email: 'test123@very.long.domain.com', expected: '*****23@very.long.domain.com'),
    (email: 'test@very.long.domain.com', expected: '*****st@very.long.domain.com'),
  ], (t) {
    test(
      'shortenEmail(${t.email})',
      () {
        final result = obscureEmail(t.email);
        expect(result, t.expected);
      },
    );
  });

  parameterizedGroup('obscurePhoneNumber', [
    (phoneNumber: '+1234567890', expected: '+1*****90'),
    (phoneNumber: '1234567890', expected: '1*****90'),
    (phoneNumber: '+10', expected: '+1*****0'),
  ], (t) {
    test(
      'shortenPhoneNumber(${t.phoneNumber})',
      () {
        final result = obscurePhoneNumber(t.phoneNumber);
        expect(result, t.expected);
      },
    );
  });
}
