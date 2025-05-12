// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/utils/text_input_formatters.dart';

void main() {
  group('CoinInputFormatter', () {
    final formatter = CoinInputFormatter();

    TextEditingValue applyFormatter(String oldText, String newText, {int cursorOffset = -1}) {
      final oldValue = TextEditingValue(
        text: oldText,
        selection: TextSelection.collapsed(offset: oldText.length),
      );
      final newValue = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: cursorOffset == -1 ? newText.length : cursorOffset,
        ),
      );
      return formatter.formatEditUpdate(oldValue, newValue);
    }

    test('adds commas correctly to integer input', () {
      final result = applyFormatter('1,000', '1,0000');
      expect(result.text, '10,000');
    });

    test('replaces old comma with decimal separator correctly', () {
      final result = applyFormatter('1,000', '1,,000');
      expect(result.text, '1.000');
    });

    test('appends decimal separator', () {
      final result = applyFormatter('10,000', '10,000,');
      expect(result.text, '10,000.');
    });

    test('formats decimal input with commas', () {
      final result = applyFormatter('10,000.5', '10,000.50');
      expect(result.text, '10,000.50');
    });

    test('deletes digits properly', () {
      final result = applyFormatter('10,000.50', '10,00.50');
      expect(result.text, '1,000.50');
    });

    test('handles input starting with zero', () {
      final result = applyFormatter('0', '00');
      expect(result.text, '0');
    });

    test('limits decimal digits', () {
      const longDecimal = '1.12345678901234567890123';
      final result = applyFormatter('1.12345678901234567890', longDecimal);
      expect(result.text, '1.12345678901234567890');
    });

    test('inserts decimal separator in middle of number', () {
      final result = applyFormatter('12,345', '12,34,5', cursorOffset: 5);
      expect(result.text, '1,234.5');
    });

    test('removes comma safely', () {
      final result = applyFormatter('1,234.5', '1234.5');
      expect(result.text, '1,234.5');
    });
  });
}
