// SPDX-License-Identifier: ice License 1.0

import 'package:dlibphonenumber/dlibphonenumber.dart';

String obscureEmail(String email) {
  // Find the index of the '@' symbol.
  final atIndex = email.indexOf('@');
  if (atIndex == -1) return email; // Fallback: if email is malformed, return it unchanged.

  // Extract the local and domain parts.
  final localPart = email.substring(0, atIndex);
  final domainPart = email.substring(atIndex);

  // If the local part is 1 character, use it as-is.
  // Otherwise, take the last two characters.
  final visiblePart = localPart.length <= 1 ? localPart : localPart.substring(localPart.length - 2);

  // Prepend five asterisks and return the new email.
  return '*****$visiblePart$domainPart';
}

String shortenAddress(String address) {
  if (address.length < 42) {
    return address;
  }
  return '${address.substring(0, 12)}...'
      '${address.substring(address.length - 14, address.length)}';
}

String obscurePhoneNumber(String phone) {
  // Determine prefix: if the phone starts with '+', take the first two characters;
  // otherwise, take the first character.
  final prefix = phone.startsWith('+')
      ? (phone.length >= 2 ? phone.substring(0, 2) : phone)
      : phone.substring(0, 1);

  // Determine suffix: if there are any characters beyond the prefix,
  // take the last two characters but make sure not to overlap the prefix.
  var suffix = '';
  if (phone.length > prefix.length) {
    var startIndex = phone.length - 2;
    // Ensure we don't start before the end of the prefix.
    if (startIndex < prefix.length) {
      startIndex = prefix.length;
    }
    suffix = phone.substring(startIndex);
  }

  return '$prefix*****$suffix';
}

String formatPhoneNumber(String countryCode, String phoneNumber) {
  return PhoneNumberUtil.instance.format(
    PhoneNumberUtil.instance.parse('$countryCode$phoneNumber', null),
    PhoneNumberFormat.e164,
  );
}
