// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'pubkey_tag.c.freezed.dart';

@freezed
class PubkeyTag with _$PubkeyTag {
  const factory PubkeyTag({
    required String? value,
  }) = _PubkeyTag;

  const PubkeyTag._();

  factory PubkeyTag.fromTags(List<List<String>> tags) {
    final tag = tags.firstWhereOrNull((tag) => tag[0] == tagName);

    if (tag == null) {
      return const PubkeyTag(value: null);
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
