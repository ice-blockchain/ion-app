// SPDX-License-Identifier: ice License 1.0

import 'package:dlibphonenumber/dlibphonenumber.dart';

String shortenEmail(String email) {
  final atIndex = email.indexOf('@');

  final firstPart = atIndex <= 4 ? email.substring(0, 1) : email.substring(0, 4);
  final lastPart = email.substring(atIndex);

  return '$firstPart...$lastPart';
}

String shortenAddress(String address) {
  assert(address.length == 42, 'Address must be 42 characters long');

  return '${address.substring(0, 12)}...'
      '${address.substring(address.length - 14, address.length)}';
}

String formatPhoneNumber(String countryCode, String phoneNumber) {
  return PhoneNumberUtil.instance.format(
    PhoneNumberUtil.instance.parse('$countryCode$phoneNumber', null),
    PhoneNumberFormat.e164,
  );
}
