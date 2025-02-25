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
    return isEmpty(value) ||
        !RegExp(
          r'^(?!.*[\u0300-\u036F\u0489])'
          r"[\p{L}\p{N}\p{So} .'-|]+$",
          unicode: true,
        ).hasMatch(value!);
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

  static String normalizeUrl(String url) {
    // Remove leading/trailing whitespace
    var normalizedUrl = url.trim();

    // Remove any mailto: prefix
    if (normalizedUrl.startsWith('mailto:')) {
      return normalizedUrl;
    }

    // Handle common messenger/social media protocols
    if (normalizedUrl.startsWith(RegExp('^(tg|fb|twitter|whatsapp)://'))) {
      return normalizedUrl;
    }

    // Remove multiple forward slashes except for protocol
    normalizedUrl = normalizedUrl.replaceAll(RegExp('([^:])//+'), r'$1/');

    // Handle protocol-relative URLs (starting with //)
    if (normalizedUrl.startsWith('//')) {
      return 'https:$normalizedUrl';
    }

    // Add https:// if no protocol is present
    if (!normalizedUrl.startsWith(RegExp('^[a-zA-Z]+://'))) {
      // Remove any leading slashes before adding https://
      normalizedUrl = normalizedUrl.replaceAll(RegExp('^/+'), '');
      normalizedUrl = 'https://$normalizedUrl';
    }

    return normalizedUrl;
  }

  static bool isInvalidUrl(String? value) {
    if (isEmpty(value)) return true;

    final normalizedUrl = normalizeUrl(value!);
    return !(Uri.tryParse(normalizedUrl)?.hasScheme).falseOrValue;
  }
}
