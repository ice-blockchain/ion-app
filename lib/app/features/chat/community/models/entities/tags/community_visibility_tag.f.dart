// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'community_visibility_tag.f.freezed.dart';

@freezed
class CommunityVisibilityTag with _$CommunityVisibilityTag {
  const factory CommunityVisibilityTag({
    required bool isPublic,
  }) = _CommunityVisibilityTag;

  const CommunityVisibilityTag._();

  factory CommunityVisibilityTag.fromTags(List<List<String>> tags) {
    final tag = tags.firstWhere((tag) => tag[0] == publicTagName || tag[0] == privateTagName);

    if (tag[0] != publicTagName && tag[0] != privateTagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: publicTagName);
    }

    return CommunityVisibilityTag(isPublic: tag[0] == publicTagName);
  }

  static const String publicTagName = 'public';
  static const String privateTagName = 'private';

  List<String> toTag() {
    return [if (isPublic) publicTagName else privateTagName];
  }
}
