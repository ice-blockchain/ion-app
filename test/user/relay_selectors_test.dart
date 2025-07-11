// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/user/providers/relays/relay_selectors.dart';

void main() {
  group('findMostMatchingOptions tests', () {
    test('findMostMatchingOptions returns best options', () {
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

    test('findMostMatchingOptions removes duplicates in best options', () {
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

    test('findMostMatchingOptions handles empty input', () {
      final input = <String, List<String>>{};
      final bestOptions = findMostMatchingOptions(input);

      expect(bestOptions, <String, List<String>>{});
    });

    test('findMostMatchingOptions handles entries with empty options', () {
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

  group('findPriorityOptions tests', () {
    test('findPriorityOptions returns options by priority', () {
      final input = {
        'key1': ['option1', 'option2', 'option3', 'option7'],
        'key2': ['option4', 'option5', 'option6', 'option7'],
        'key3': ['option8', 'option9', 'option10', 'option11'],
      };
      final priority = [
        'option9',
        'option8',
        'option7',
        'option6',
        'option5',
        'option4',
        'option3',
        'option2',
        'option1',
      ];
      final result = findPriorityOptions(input, optionsPriority: priority);
      expect(result, {
        'option9': ['key3'],
        'option7': ['key1', 'key2'],
      });
    });

    test('findPriorityOptions handles empty input', () {
      final input = <String, List<String>>{};
      final priority = ['option1', 'option2'];
      final result = findPriorityOptions(input, optionsPriority: priority);
      expect(result, <String, List<String>>{});
    });

    test('findPriorityOptions handles empty priority', () {
      final input = {
        'key1': ['option1', 'option2'],
      };
      final priority = <String>[];
      final result = findPriorityOptions(input, optionsPriority: priority);
      expect(result, <String, List<String>>{});
    });

    test('findPriorityOptions skips options not in priority', () {
      final input = {
        'key1': ['option1', 'option2'],
        'key2': ['option3'],
      };
      final priority = ['option2'];
      final result = findPriorityOptions(input, optionsPriority: priority);
      expect(result, {
        'option2': ['key1'],
      });
    });

    test('findPriorityOptions handles duplicate options', () {
      final input = {
        'key1': ['option1', 'option1', 'option2'],
        'key2': ['option2', 'option2'],
      };
      final priority = ['option2', 'option1'];
      final result = findPriorityOptions(input, optionsPriority: priority);
      expect(result, {
        'option2': ['key1', 'key2'],
      });
    });
  });
}
