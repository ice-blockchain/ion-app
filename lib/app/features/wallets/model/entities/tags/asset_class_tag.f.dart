// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'asset_class_tag.f.freezed.dart';

@freezed
class AssetClassTag with _$AssetClassTag {
  const factory AssetClassTag({
    required String value,
  }) = _AssetClassTag;

  const AssetClassTag._();

  factory AssetClassTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return AssetClassTag(value: tag[1]);
  }

  static const String tagName = 'asset_class';

  List<String> toTag() {
    return [tagName, value];
  }
}
