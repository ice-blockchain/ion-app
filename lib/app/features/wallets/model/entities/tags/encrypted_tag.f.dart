// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'encrypted_tag.f.freezed.dart';

@freezed
class EncryptedTag with _$EncryptedTag {
  const factory EncryptedTag() = _EncryptedTag;

  const EncryptedTag._();

  factory EncryptedTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    return const EncryptedTag();
  }

  static const String tagName = 'encrypted';

  List<String> toTag() => [tagName];
}
