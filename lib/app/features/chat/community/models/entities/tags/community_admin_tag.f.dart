// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'community_admin_tag.f.freezed.dart';

@freezed
class CommunityAdminTag with _$CommunityAdminTag {
  const factory CommunityAdminTag({
    required String value,
  }) = _CommunityAdminTag;

  const CommunityAdminTag._();

  factory CommunityAdminTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    if (tag.length != 4) {
      throw IncorrectEventTagValueException(tag: tagName, value: tag.toString());
    }

    return CommunityAdminTag(value: tag[1]);
  }

  static const String tagName = 'p';
  static const String roleValue = 'admin';

  List<String> toTag() {
    return [tagName, value, '', roleValue];
  }
}
