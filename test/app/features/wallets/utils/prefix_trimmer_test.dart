// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/wallets/utils/prefix_trimmer.dart';

import '../../../../test_utils.dart';

void main() {
  parameterizedGroup('default trimPrefix behavior', [
    (value: 'abc', expected: 'abc'),
    (value: 'abc:def', expected: 'def'),
    (value: 'abc:', expected: ''),
    (value: ':def', expected: 'def'),
    (value: 'abc:def:ghi', expected: 'def:ghi'),
  ], (t) {
    test(
      'trimPrefix(${t.value})',
      () {
        final result = trimPrefix(t.value);
        expect(result, t.expected);
      },
    );
  });
  group(
    'custom separator for trimPrefix',
    () {
      const value = 'abc,def';
      const expected = 'def';
      const separator = ',';
      test('trimPrefix($value, separator=$separator)', () {
        final result = trimPrefix(value, separator: separator);
        expect(result, expected);
      });
    },
  );
}
