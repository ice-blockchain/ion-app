// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'community_moderator_tag.c.freezed.dart';

@freezed
class CommunityModeratorTag with _$CommunityModeratorTag {
  const factory CommunityModeratorTag({
    required String value,
  }) = _CommunityModeratorTag;

  const CommunityModeratorTag._();

  factory CommunityModeratorTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    if (tag.length != 4) {
      throw IncorrectEventTagValueException(tag: tagName, value: tag.toString());
    }

    return CommunityModeratorTag(value: tag[1]);
  }

  static const String tagName = 'p';
  static const String roleValue = 'moderator';

  List<String> toTag() {
    return [tagName, value, '', roleValue];
  }
}
