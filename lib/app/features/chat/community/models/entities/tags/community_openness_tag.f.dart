// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'community_openness_tag.f.freezed.dart';

@freezed
class CommunityOpennessTag with _$CommunityOpennessTag {
  const factory CommunityOpennessTag({
    required bool isOpen,
  }) = _CommunityOpennessTag;

  const CommunityOpennessTag._();

  factory CommunityOpennessTag.fromTags(List<List<String>> tags) {
    final tag = tags.firstWhere((tag) => tag[0] == openTagName || tag[0] == closedTagName);

    if (tag[0] != openTagName && tag[0] != closedTagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: openTagName);
    }

    return CommunityOpennessTag(isOpen: tag[0] == openTagName);
  }

  static const String openTagName = 'open';
  static const String closedTagName = 'closed';

  List<String> toTag() {
    return [if (isOpen) openTagName else closedTagName];
  }
}
