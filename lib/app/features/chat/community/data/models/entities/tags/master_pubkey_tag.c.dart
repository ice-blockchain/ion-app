// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'master_pubkey_tag.c.freezed.dart';

@freezed
class MasterPubkeyTag with _$MasterPubkeyTag {
  const factory MasterPubkeyTag({
    required String? value,
  }) = _MasterPubkeyTag;

  const MasterPubkeyTag._();

  factory MasterPubkeyTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return MasterPubkeyTag(value: tag[1]);
  }

  static const String tagName = 'b';

  List<String> toTag() {
    if (value == null) {
      throw IncorrectEventTagValueException(tag: tagName, value: value);
    }
    return [tagName, value!];
  }
}
