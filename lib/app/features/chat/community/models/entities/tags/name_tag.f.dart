// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'name_tag.f.freezed.dart';

@freezed
class NameTag with _$NameTag {
  const factory NameTag({
    required String value,
  }) = _NameTag;

  const NameTag._();

  factory NameTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return NameTag(value: tag[1]);
  }

  static const String tagName = 'name';

  List<String> toTag() {
    return [tagName, value];
  }
}
