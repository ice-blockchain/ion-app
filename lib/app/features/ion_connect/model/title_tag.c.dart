// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'title_tag.c.freezed.dart';

@freezed
class TitleTag with _$TitleTag {
  const factory TitleTag({required String value}) = _TitleTag;

  const TitleTag._();

  factory TitleTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return TitleTag(value: tag[1]);
  }

  static const String tagName = 'title';

  List<String> toTag() => [tagName, value];
}
