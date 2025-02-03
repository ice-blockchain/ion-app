// SPDX-License-Identifier: ice License 1.0

import 'package:dlibphonenumber/dlibphonenumber.dart';

String shortenEmail(String email) {
  final atIndex = email.indexOf('@');

  final firstPart = atIndex <= 4 ? email.substring(0, 1) : email.substring(0, 4);
  final lastPart = email.substring(atIndex);

  return '$firstPart...$lastPart';
}

String shortenAddress(String address) {
  if (address.length < 42) {
    return address;
  }
  return '${address.substring(0, 12)}...'
      '${address.substring(address.length - 14, address.length)}';
}

String shortenPhoneNumber(String phoneNumber) {
  final firstPart = phoneNumber.substring(0, 5);
  final lastPart = phoneNumber.substring(phoneNumber.length - 2);

  return '$firstPart...$lastPart';
}

String formatPhoneNumber(String countryCode, String phoneNumber) {
  return PhoneNumberUtil.instance.format(
    PhoneNumberUtil.instance.parse('$countryCode$phoneNumber', null),
    PhoneNumberFormat.e164,
  );
}
