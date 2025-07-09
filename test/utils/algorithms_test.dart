// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/utils/algorithm.dart';

void main() {
  group('findBestOptions tests', () {
    test('findBestOptions returns best options', () {
      final input = {
        'key1': ['option1', 'option2'],
        'key2': ['option1', 'option3'],
        'key3': ['option1', 'option4'],
        'key4': ['option2', 'option4'],
        'key5': ['option3', 'option4'],
        'key6': ['option5'],
      };
      final bestOptions = findMostMatchingOptions(input);

      expect(bestOptions, {
        'option1': ['key1', 'key2', 'key3'],
        'option4': ['key4', 'key5'],
        'option5': ['key6'],
      });
    });

    test('findBestOptions removes duplicates in best options', () {
      final input = {
        'key1': ['option1', 'option2'],
        'key2': ['option1', 'option3'],
        'key3': ['option4', 'option4', 'option4'],
      };
      final bestOptions = findMostMatchingOptions(input);

      expect(bestOptions, {
        'option1': ['key1', 'key2'],
        'option4': ['key3'],
      });
    });

    test('findBestOptions handles empty input', () {
      final input = <String, List<String>>{};
      final bestOptions = findMostMatchingOptions(input);

      expect(bestOptions, <String, List<String>>{});
    });

    test('findBestOptions handles entries with empty options', () {
      final input = {
        'key1': ['option1', 'option2'],
        'key2': ['option2', 'option3'],
        'key3': <String>[],
      };
      final bestOptions = findMostMatchingOptions(input);

      expect(bestOptions, {
        'option2': ['key1', 'key2'],
      });
    });
  });
}
