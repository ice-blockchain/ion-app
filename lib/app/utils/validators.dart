// SPDX-License-Identifier: ice License 1.0

import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ion/app/extensions/extensions.dart';

class Validators {
  Validators._();

  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  static bool isInvalidIdentityName(String? value) {
    return isEmpty(value) || !RegExp(r'^[a-z0-9._-]+$').hasMatch(value!);
  }

  static bool isInvalidEmail(String? value) {
    return isEmpty(value) || !EmailValidator.validate(value!);
  }

  static bool isInvalidDisplayName(String? value) {
    return isEmpty(value) || !RegExp(r'[\u{1D400}-\u{1D7FF}]', unicode: true).hasMatch(value!);
  }

  static bool isInvalidNickname(String? value) {
    return isEmpty(value) || !RegExp(r'^[a-zA-Z0-9.]+$').hasMatch(value!);
  }

  static bool isInvalidLength(String? value, {int? minLength, int? maxLength}) {
    assert(
      minLength != null || maxLength != null,
      'At least one of minLength or maxLength must be provided',
    );

    if (value == null) return true;
    if (minLength != null && value.length < minLength) return true;
    if (maxLength != null && value.length > maxLength) return true;

    return false;
  }

  static bool hasNoDigits(String? value) {
    return isEmpty(value) || !RegExp(r'\d').hasMatch(value!);
  }

  static bool hasNoUppercaseOrLowercaseLetters(String? value) {
    return isEmpty(value) || !(RegExp('[A-Z]').hasMatch(value!) && RegExp('[a-z]').hasMatch(value));
  }

  static bool hasNoSpecialChars(String? value) {
    return isEmpty(value) || !RegExp(r'[^a-zA-Z0-9\s]').hasMatch(value!);
  }

  static bool isInvalidNumber(String? value) {
    return isEmpty(value) || double.tryParse(value!) == null;
  }

  static bool isValidPhoneNumber(String? countryCode, String? phoneNumber) {
    try {
      return !isEmpty(phoneNumber) &&
          PhoneNumberUtil.instance.isPossibleNumber(
            PhoneNumberUtil.instance.parse('$countryCode$phoneNumber', null),
          );
    } catch (e) {
      return false;
    }
  }

  static bool isPollValid(String pollTitle, List<String> pollAnswers) {
    return pollTitle.trim().isNotEmpty &&
        pollAnswers.length >= 2 &&
        pollAnswers.every(
          (answer) => answer.trim().isNotEmpty && answer.trim().length <= 25,
        );
  }

  static bool isInvalidUrl(String? value) {
    return isEmpty(value) || !(Uri.tryParse(value!)?.isAbsolute).falseOrValue;
  }
}
