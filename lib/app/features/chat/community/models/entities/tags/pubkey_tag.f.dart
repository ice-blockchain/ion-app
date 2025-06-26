// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'pubkey_tag.f.freezed.dart';

@freezed
class PubkeyTag with _$PubkeyTag {
  const factory PubkeyTag({
    required String? value,
  }) = _PubkeyTag;

  const PubkeyTag._();

  factory PubkeyTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return PubkeyTag(value: tag[1]);
  }

  static const String tagName = 'p';

  List<String> toTag() {
    if (value == null) {
      throw IncorrectEventTagValueException(tag: tagName, value: value);
    }
    return [tagName, value!];
  }
}
