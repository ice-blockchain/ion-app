// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'description_tag.f.freezed.dart';

@freezed
class DescriptionTag with _$DescriptionTag {
  const factory DescriptionTag({
    required String? value,
  }) = _DescriptionTag;

  const DescriptionTag._();

  factory DescriptionTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return DescriptionTag(value: tag[1]);
  }

  static const String tagName = 'description';

  List<String> toTag() {
    if (value == null) {
      throw IncorrectEventTagValueException(tag: tagName, value: value);
    }
    return [tagName, value!];
  }
}
