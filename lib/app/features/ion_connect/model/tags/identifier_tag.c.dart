// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'identifier_tag.c.freezed.dart';

@freezed
class IdentifierTag with _$IdentifierTag {
  const factory IdentifierTag({
    required String value,
  }) = _IdentifierTag;

  const IdentifierTag._();

  factory IdentifierTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return IdentifierTag(value: tag[1]);
  }

  static const String tagName = 'd';

  List<String> toTag() {
    return [tagName, value];
  }
}
