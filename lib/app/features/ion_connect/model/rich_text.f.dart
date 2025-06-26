// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'rich_text.f.freezed.dart';

@freezed
class RichText with _$RichText {
  const factory RichText({
    required String protocol,
    required String content,
  }) = _RichText;

  const RichText._();

  factory RichText.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length < 3) {
      throw IncorrectEventTagException(tag: tag.toString());
    }
    return RichText(protocol: tag[1], content: tag[2]);
  }

  List<String> toTag() {
    return [tagName, protocol, content];
  }

  static const String tagName = 'rich_text';
}
