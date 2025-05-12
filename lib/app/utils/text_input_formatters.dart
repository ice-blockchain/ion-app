// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ion/app/services/logger/logger.dart';

TextInputFormatter decimalInputFormatter({required int maxDecimals}) {
  return FilteringTextInputFormatter.allow(RegExp('^\\d*\\,?\\d{0,$maxDecimals}'));
}

class CoinInputFormatter extends TextInputFormatter {
  static const int maxDecimalsNumber = 20;
  static final _numberFormat = NumberFormat('#,###', 'en_US');
  static final _commasRegex = RegExp('[^,]');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length < oldValue.text.length) {
      return _handleDeletion(oldValue, newValue);
    }

    final enteredChar = _getEnteredCharacter(oldValue, newValue);
    if (enteredChar == null) return oldValue;

    if (_isDecimalSeparator(enteredChar.newSymbol)) {
      return _handleDecimalSeparator(oldValue, newValue, enteredChar.index);
    }

    return _handleDigitInput(oldValue, newValue);
  }

  TextEditingValue _handleDeletion(TextEditingValue oldValue, TextEditingValue newValue) {
    final cursorPos = newValue.selection.end;
    final normalized = _normalizeInput(newValue.text);

    if (_isSpecialDecimalDeletion(oldValue, newValue)) {
      return newValue;
    }

    if (normalized.isEmpty) {
      return TextEditingValue(
        text: normalized,
        selection: TextSelection.collapsed(offset: cursorPos),
      );
    }

    return _formatNumberWithCursor(oldValue, normalized, cursorPos);
  }

  bool _isSpecialDecimalDeletion(TextEditingValue oldValue, TextEditingValue newValue) {
    if (!oldValue.text.contains('.') || !newValue.text.contains('.')) return false;

    final oldDecimalPart = oldValue.text.split('.')[1];
    final newDecimalPart = newValue.text.split('.')[1];
    final decimalsNumber = _countDecimals(newValue.text);

    return newDecimalPart.length < oldDecimalPart.length &&
        (decimalsNumber > 0 || newValue.text.endsWith('.'));
  }

  TextEditingValue _handleDecimalSeparator(
    TextEditingValue oldValue,
    TextEditingValue newValue,
    int index,
  ) {
    if (oldValue.text.contains('.')) {
      return oldValue;
    }

    final normalized = _normalizeInput(newValue.text);
    final isAppending = index == newValue.text.length - 1;

    try {
      if (isAppending) {
        // Handle appending decimal at the end
        final beforeDecimal = normalized.substring(0, normalized.length);
        final formatted = '${_formatIntegerPart(beforeDecimal)}.';
        return TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }

      // If inserting at position with a comma in formatted text,
      // we need to adjust the split position
      final formattedBeforeInsertion = _formatIntegerPart(normalized);
      var adjustedIndex = index;
      var commaCount = 0;
      for (var i = 0; i < formattedBeforeInsertion.length && i < index; i++) {
        if (formattedBeforeInsertion[i] == ',') {
          commaCount++;
        }
      }
      adjustedIndex -= commaCount;

      // Split the normalized number at the adjusted position
      final beforePart = normalized.substring(0, adjustedIndex);
      final afterPart = normalized.substring(adjustedIndex);
      final formatted = '${_formatIntegerPart(beforePart)}.$afterPart';
      final decimalPos = formatted.indexOf('.');

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: decimalPos + 1),
      );
    } catch (e) {
      Logger.error('Caught error during handling entered decimal separator. Exception: $e');
      return oldValue;
    }
  }

  TextEditingValue _handleDigitInput(TextEditingValue oldValue, TextEditingValue newValue) {
    final normalized = _normalizeInput(newValue.text);
    return _formatNumberWithCursor(oldValue, normalized, newValue.selection.end);
  }

  String _normalizeInput(String text) => text.replaceAll(',', '');

  bool _isDecimalSeparator(String symbol) => symbol == ',' || symbol == '.';

  String _formatIntegerPart(String input) {
    var inputToParse = input;
    if (inputToParse.isEmpty || inputToParse == '0') return '0';

    // Limit integer part to 16 digits (max safe integer has 16 digits)
    if (inputToParse.length > 16) {
      inputToParse = inputToParse.substring(0, 16);
    }

    try {
      return _numberFormat.format(int.parse(inputToParse));
    } catch (e) {
      Logger.error('Error during parsing $input to int.');
      return '0';
    }
  }

  TextEditingValue _formatNumberWithCursor(
    TextEditingValue oldValue,
    String normalized,
    int cursorPos,
  ) {
    try {
      final parts = normalized.split('.');
      final intPart = parts[0];
      final decimalPart = parts.length > 1 ? parts[1] : '';

      final limitedDecimalPart = decimalPart.length > maxDecimalsNumber
          ? decimalPart.substring(0, maxDecimalsNumber)
          : decimalPart;

      final formattedIntPart = _formatIntegerPart(intPart);
      final toDisplay =
          decimalPart.isNotEmpty ? '$formattedIntPart.$limitedDecimalPart' : formattedIntPart;

      final newCursorPos = _calculateCursorPosition(
        oldValue: oldValue,
        newText: toDisplay,
        oldCursorPos: cursorPos,
        hasLimitedDecimals: decimalPart.length > maxDecimalsNumber,
      );

      return TextEditingValue(
        text: toDisplay,
        selection: TextSelection.collapsed(
          offset: min(toDisplay.length, max(0, newCursorPos)),
        ),
      );
    } catch (e) {
      Logger.error('Caught error during formatting number. Exception: $e');
      return oldValue;
    }
  }

  int _calculateCursorPosition({
    required TextEditingValue oldValue,
    required String newText,
    required int oldCursorPos,
    required bool hasLimitedDecimals,
  }) {
    var newPos = oldCursorPos;

    final oldCommaCount = oldValue.text
        .substring(0, min(oldValue.text.length, oldCursorPos - 1))
        .replaceAll(_commasRegex, '')
        .length;

    final newCommaCount =
        newText.substring(0, min(newText.length, oldCursorPos)).replaceAll(_commasRegex, '').length;

    newPos += newCommaCount - oldCommaCount;

    if (hasLimitedDecimals && newPos > newText.length) {
      newPos = newText.length;
    }

    return newPos;
  }

  ({int index, String newSymbol})? _getEnteredCharacter(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length != oldValue.text.length + 1) return null;

    for (var i = 0; i < newValue.text.length; i++) {
      if (i >= oldValue.text.length || oldValue.text[i] != newValue.text[i]) {
        return (index: i, newSymbol: newValue.text[i]);
      }
    }
    return null;
  }

  int _countDecimals(String value) {
    final dotIndex = value.indexOf('.');
    return dotIndex == -1 ? 0 : value.length - dotIndex - 1;
  }
}
