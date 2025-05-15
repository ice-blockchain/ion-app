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
      expect(result.text, '1.123456789012345678');
    });

    test('inserts decimal separator in middle of number', () {
      final result = applyFormatter('12,345', '12,34,5', cursorOffset: 5);
      expect(result.text, '1,234.5');
    });

    test('removes comma safely', () {
      final result = applyFormatter('1,234.5', '1234.5');
      expect(result.text, '1,234.5');
    });

    test('handles pasting whole numbers', () {
      final result = applyFormatter('', '1000000');
      expect(result.text, '1,000,000');
    });

    test('handles pasting decimal numbers', () {
      final result = applyFormatter('', '1000000.50');
      expect(result.text, '1,000,000.50');
    });

    test('handles pasting before the decimals delimiter', () {
      const oldValue = TextEditingValue(
        text: '1,234.56',
        selection: TextSelection(baseOffset: 5, extentOffset: 5),
      );
      const newValue = TextEditingValue(
        text: '1,234999.56',
        selection: TextSelection.collapsed(offset: 8),
      );
      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '1,234,999.56');
    });

    test('handles pasting after the decimals delimiter', () {
      const oldValue = TextEditingValue(
        text: '1,234.56',
        selection: TextSelection(baseOffset: 7, extentOffset: 7),
      );
      const newValue = TextEditingValue(
        text: '1,234.59996',
        selection: TextSelection.collapsed(offset: 10),
      );
      final result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '1,234.59996');
    });

    test('handles pasting invalid text', () {
      const toInsert = '234oiejvoi29';
      final result = applyFormatter('1,234.56', '1,234.5${toInsert}6');
      expect(result.text, '1,234.56');
    });

    test('handles pasting with existing commas', () {
      final result = applyFormatter('', '1,000.00');
      expect(result.text, '1,000.00');
    });
  });
}
