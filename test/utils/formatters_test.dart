// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/utils/formatters.dart';

import '../test_utils.dart';

void main() {
  parameterizedGroup('shortenEmail', [
    (email: 'johndoe@example.com', expected: 'john...@example.com'),
    (email: 'joe@example.com', expected: 'j...@example.com'),
    (email: 'jane@example.com', expected: 'j...@example.com'),
    (email: 'a@example.com', expected: 'a...@example.com'),
    (email: 'test123@very.long.domain.com', expected: 'test...@very.long.domain.com'),
    (email: 'test@very.long.domain.com', expected: 't...@very.long.domain.com'),
  ], (t) {
    test(
      'shortenEmail(${t.email})',
      () {
        final result = shortenEmail(t.email);
        expect(result, t.expected);
      },
    );
  });

  parameterizedGroup('shortenPhoneNumber', [
    (phoneNumber: '+1234567890', expected: '+1234...90'),
  ], (t) {
    test(
      'shortenPhoneNumber(${t.phoneNumber})',
      () {
        final result = shortenPhoneNumber(t.phoneNumber);
        expect(result, t.expected);
      },
    );
  });
}
