// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'asset_address_tag.f.freezed.dart';

@freezed
class AssetAddressTag with _$AssetAddressTag {
  const factory AssetAddressTag({
    required String value,
  }) = _AssetAddressTag;

  const AssetAddressTag._();

  factory AssetAddressTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return AssetAddressTag(value: tag[1]);
  }

  static const String tagName = 'asset_address';

  List<String> toTag() {
    return [tagName, value];
  }
}
