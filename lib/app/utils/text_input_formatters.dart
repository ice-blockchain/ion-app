// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

TextInputFormatter decimalInputFormatter({required int maxDecimals}) {
  return FilteringTextInputFormatter.allow(RegExp('^\\d*\\,?\\d{0,$maxDecimals}'));
}

class CoinInputFormatter extends TextInputFormatter {
  // Maximum number of decimal places allowed (to avoid RangeError)
  static const int maxDecimalsNumber = 20;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Handle the removed symbol
    if (newValue.text.length < oldValue.text.length) {
      final cursorPos = newValue.selection.end;
      final normalized = newValue.text.replaceAll(',', '');
      final decimalsNumber = _countDecimals(newValue.text);

      // Handle special case when removing character after the decimal point
      if (oldValue.text.contains('.') && newValue.text.contains('.')) {
        final oldDecimalPart = oldValue.text.split('.')[1];
        final newDecimalPart = newValue.text.split('.')[1];

        if (newDecimalPart.length < oldDecimalPart.length) {
          if (decimalsNumber > 0 || newValue.text.endsWith('.')) {
            return newValue;
          }
        }
      }

      // If not all symbols were removed
      if (normalized.isNotEmpty) {
        // Don't use double.tryParse here to preserve exact decimal digits
        // Just reformat with commas as needed
        if (normalized.contains('.')) {
          final parts = normalized.split('.');
          final intPart = parts[0].isEmpty ? '0' : parts[0];
          final decimalPart = parts.length > 1 ? parts[1] : '';

          try {
            final formattedIntPart =
                intPart == '0' ? '0' : NumberFormat('#,###', 'en_US').format(int.parse(intPart));

            final toDisplay = decimalPart.isNotEmpty || normalized.endsWith('.')
                ? '$formattedIntPart.$decimalPart'
                : formattedIntPart;

            // Calculate new cursor position
            var newCursorPos = cursorPos;
            final commasRegex = RegExp('[^,]');
            final oldCommaCount =
                oldValue.text.substring(0, cursorPos).replaceAll(commasRegex, '').length;
            final newCommaCount = toDisplay
                .substring(0, min(cursorPos, toDisplay.length))
                .replaceAll(commasRegex, '')
                .length;
            newCursorPos += newCommaCount - oldCommaCount;

            return TextEditingValue(
              text: toDisplay,
              selection:
                  TextSelection.collapsed(offset: min(toDisplay.length, max(0, newCursorPos))),
            );
          } catch (e, st) {
            return newValue;
          }
        } else {
          // Just integers, no decimal part
          try {
            final toDisplay = normalized == '0'
                ? '0'
                : NumberFormat('#,###', 'en_US').format(int.parse(normalized));

            // Calculate new cursor position
            var newCursorPos = cursorPos;
            final commasRegex = RegExp('[^,]');
            final oldCommaCount =
                oldValue.text.substring(0, cursorPos).replaceAll(commasRegex, '').length;
            final newCommaCount = toDisplay
                .substring(0, min(cursorPos, toDisplay.length))
                .replaceAll(commasRegex, '')
                .length;
            newCursorPos += newCommaCount - oldCommaCount;

            return TextEditingValue(
              text: toDisplay,
              selection:
                  TextSelection.collapsed(offset: min(toDisplay.length, max(0, newCursorPos))),
            );
          } catch (e, st) {
            return newValue;
          }
        }
      }

      // If nothing left or couldn't parse
      return TextEditingValue(
        text: normalized,
        selection: TextSelection.collapsed(offset: cursorPos),
      );
    }

    // Handle addition of characters
    final newText = newValue.text;
    final enteredCharResult = _getEnteredCharacter(oldValue, newValue);

    // If no new character identified, return old value
    if (enteredCharResult == null) {
      return oldValue;
    }

    final index = enteredCharResult.index;
    final newSymbol = enteredCharResult.newSymbol;
    final isNewSymbolDecimalsSeparator = newSymbol == ',' || newSymbol == '.';
    final isTheLastCharEntered = index == newValue.text.length - 1;

    // Handle insertion of decimal separator
    if (isNewSymbolDecimalsSeparator) {
      // Old value already contains the decimals separator. It can be only one.
      if (oldValue.text.contains('.')) {
        return oldValue;
      }

      // Insert decimal separator at the proper position
      if (isTheLastCharEntered) {
        // Handle appending decimal at the end
        final normalized = newText.substring(0, newText.length - 1).replaceAll(',', '');

        try {
          final intValue = normalized.isEmpty ? 0 : int.parse(normalized);
          final formattedText = '${NumberFormat('#,###', 'en_US').format(intValue)}.';

          return TextEditingValue(
            text: formattedText,
            selection: TextSelection.collapsed(offset: formattedText.length),
          );
        } catch (e, st) {
          return oldValue;
        }
      } else {
        // Handle inserting decimal in the middle
        // Extract parts before and after the insertion point
        final beforePart = newText.substring(0, index).replaceAll(',', '');
        final afterPart = newText.substring(index + 1).replaceAll(',', '');

        try {
          // Format the integer part
          final intValue = beforePart.isEmpty ? 0 : int.parse(beforePart);
          final formattedIntPart = NumberFormat('#,###', 'en_US').format(intValue);

          // Combine with decimal part
          final formattedText = '$formattedIntPart.$afterPart';

          // Find position of the decimal point in formatted text
          final decimalPos = formattedText.indexOf('.');

          return TextEditingValue(
            text: formattedText,
            selection: TextSelection.collapsed(offset: decimalPos + 1),
          );
        } catch (e, st) {
          return oldValue;
        }
      }
    }

    // Handle regular digit input
    final normalized = newValue.text.replaceAll(',', '');

    // Check if we're dealing with a decimal number
    if (normalized.contains('.')) {
      final parts = normalized.split('.');
      final intPart = parts[0].isEmpty ? '0' : parts[0];
      final decimalPart = parts.length > 1 ? parts[1] : '';

      // Limit the decimal places to avoid errors
      final limitedDecimalPart = decimalPart.length > maxDecimalsNumber
          ? decimalPart.substring(0, maxDecimalsNumber)
          : decimalPart;

      try {
        final formattedIntPart =
            intPart == '0' ? '0' : NumberFormat('#,###', 'en_US').format(int.parse(intPart));

        final toDisplay = '$formattedIntPart.$limitedDecimalPart';

        // Calculate new cursor position
        var newCursorPos = newValue.selection.end;
        final oldCommaCount = oldValue.text
            .substring(0, min(oldValue.text.length, newValue.selection.end - 1))
            .replaceAll(RegExp('[^,]'), '')
            .length;
        final newCommaCount = toDisplay
            .substring(0, min(toDisplay.length, newValue.selection.end))
            .replaceAll(RegExp('[^,]'), '')
            .length;
        newCursorPos += newCommaCount - oldCommaCount;

        // Adjust cursor if we've limited decimal places
        if (decimalPart.length > maxDecimalsNumber && newCursorPos > toDisplay.length) {
          newCursorPos = toDisplay.length;
        }

        return TextEditingValue(
          text: toDisplay,
          selection: TextSelection.collapsed(offset: min(toDisplay.length, max(0, newCursorPos))),
        );
      } catch (e, st) {
        return oldValue;
      }
    } else {
      // Integer part only
      try {
        // Avoid double conversion to preserve exact input
        final toDisplay =
            normalized == '0' ? '0' : NumberFormat('#,###', 'en_US').format(int.parse(normalized));

        // Calculate new cursor position
        var newCursorPos = newValue.selection.end;
        final oldCommaCount = oldValue.text
            .substring(0, min(oldValue.text.length, newValue.selection.end - 1))
            .replaceAll(RegExp('[^,]'), '')
            .length;
        final newCommaCount = toDisplay
            .substring(0, min(toDisplay.length, newValue.selection.end))
            .replaceAll(RegExp('[^,]'), '')
            .length;
        newCursorPos += newCommaCount - oldCommaCount;

        return TextEditingValue(
          text: toDisplay,
          selection: TextSelection.collapsed(offset: min(toDisplay.length, max(0, newCursorPos))),
        );
      } catch (e, st) {
        return oldValue;
      }
    }
  }

  ({int index, String newSymbol})? _getEnteredCharacter(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldText = oldValue.text;
    final newText = newValue.text;
    final oldLength = oldText.length;
    final newLength = newText.length;

    // Check if a single character was added
    if (newLength == oldLength + 1) {
      for (var i = 0; i < newLength; i++) {
        if (i >= oldLength || oldText[i] != newText[i]) {
          return (index: i, newSymbol: newText[i]);
        }
      }
    }
    return null;
  }

  int _countDecimals(String value) {
    // Should be only one dot according to the selected format
    final dotIndex = value.indexOf('.');
    if (dotIndex == -1) return 0; // No decimal point
    return value.length - dotIndex - 1;
  }
}
