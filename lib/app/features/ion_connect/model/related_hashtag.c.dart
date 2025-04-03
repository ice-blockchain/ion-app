// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'related_hashtag.c.freezed.dart';

@freezed
class RelatedHashtag with _$RelatedHashtag {
  const factory RelatedHashtag({
    required String value,
  }) = _RelatedHashtag;

  const RelatedHashtag._();

  /// https://github.com/nostr-protocol/nips/blob/master/24.md#tags
  factory RelatedHashtag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length < 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }
    return RelatedHashtag(value: tag[1]);
  }

  List<String> toTag() {
    return [tagName, value.toLowerCase()];
  }

  static bool isTag(String input) {
    // starts with # or $ and contains only 1 word
    return RegExp(r'^[#\$]\S+$').hasMatch(input);
  }

  static const String tagName = 't';
}
