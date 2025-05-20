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

  group('replacePlaceholders', () {
    test('replaces single placeholder', () {
      expect(
        replacePlaceholders('Hello, {{name}}!', {'name': 'Alice'}),
        'Hello, Alice!',
      );
    });

    test('replaces multiple placeholders', () {
      expect(
        replacePlaceholders('Hi {{name}}, welcome to {{place}}.', {
          'name': 'Bob',
          'place': 'Earth',
        }),
        'Hi Bob, welcome to Earth.',
      );
    });

    test('leaves unknown placeholders unchanged', () {
      expect(
        replacePlaceholders('Hello, {{name}}!', {}),
        'Hello, {{name}}!',
      );
    });

    test('trims placeholder keys', () {
      expect(
        replacePlaceholders('Hi {{ name }}!', {'name': 'Eve'}),
        'Hi Eve!',
      );
    });

    test('works with repeated placeholders', () {
      expect(
        replacePlaceholders('{{a}} {{a}}', {'a': 'X'}),
        'X X',
      );
    });

    test('works with no placeholders', () {
      expect(
        replacePlaceholders('No placeholders here.', {'foo': 'bar'}),
        'No placeholders here.',
      );
    });
  });

  group('hasPlaceholders', () {
    test('returns true if placeholder exists', () {
      expect(hasPlaceholders('Hello, {{name}}!'), isTrue);
    });

    test('returns false if no placeholder exists', () {
      expect(hasPlaceholders('Hello, world!'), isFalse);
    });

    test('returns true for multiple placeholders', () {
      expect(hasPlaceholders('Hi {{a}}, {{b}}!'), isTrue);
    });

    test('returns true for placeholder with spaces', () {
      expect(hasPlaceholders('Test {{ key }}'), isTrue);
    });

    test('returns false for empty string', () {
      expect(hasPlaceholders(''), isFalse);
    });
  });
}
