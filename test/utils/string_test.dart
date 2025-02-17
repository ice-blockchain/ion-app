// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/utils/string.dart';

import '../test_utils.dart';

void main() {
  parameterizedGroup('capitalize string value', [
    (value: '', expected: ''),
    (value: 'A', expected: 'A'),
    (value: 'a', expected: 'A'),
    (value: 'AAA', expected: 'AAA'),
    (value: 'aaa', expected: 'Aaa'),
  ], (t) {
    test(
      '${t.value}.capitalize()',
      () {
        expect(t.value.capitalize(), t.expected);
      },
    );
  });
}
