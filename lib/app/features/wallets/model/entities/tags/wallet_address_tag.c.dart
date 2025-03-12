// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'wallet_address_tag.c.freezed.dart';

@freezed
class WalletAddressTag with _$WalletAddressTag {
  const factory WalletAddressTag({required String value}) = _WalletAddressTag;

  const WalletAddressTag._();

  factory WalletAddressTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return WalletAddressTag(value: tag[1]);
  }

  static const String tagName = 'l';

  List<String> toTag() => [tagName, value];
}
