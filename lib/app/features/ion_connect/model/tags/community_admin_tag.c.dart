import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_admin_tag.c.freezed.dart';

@freezed
class CommunityAdminTag with _$CommunityAdminTag {
  const factory CommunityAdminTag({
    required List<String> values,
  }) = _CommunityAdminTag;

  const CommunityAdminTag._();

  factory CommunityAdminTag.fromTags(List<List<String>> tags) {
    final tag = tags.where((tag) => tag[0] == tagName && tag[2] == roleValue);

    if (tag.isEmpty) {
      return const CommunityAdminTag(values: []);
    }

    return CommunityAdminTag(values: tag.map((tag) => tag[1]).toList());
  }

  static const String tagName = 'p';
  static const String roleValue = 'admin';

  List<List<String>> toTag() {
    return values.map((value) => [tagName, value, roleValue]).toList();
  }
}
