// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'related_token.c.freezed.dart';

@freezed
class RelatedToken with _$RelatedToken {
  const factory RelatedToken({
    required String value,
  }) = _RelatedToken;

  const RelatedToken._();

  factory RelatedToken.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return RelatedToken(value: tag[1]);
  }

  static const String tagName = 'token';

  List<String> toTag() {
    return [tagName, value];
  }
}
