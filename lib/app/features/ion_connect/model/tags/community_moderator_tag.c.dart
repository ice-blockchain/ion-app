import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_moderator_tag.c.freezed.dart';

@freezed
class CommunityModeratorTag with _$CommunityModeratorTag {
  const factory CommunityModeratorTag({
    required List<String> values,
  }) = _CommunityModeratorTag;

  const CommunityModeratorTag._();

  factory CommunityModeratorTag.fromTags(List<List<String>> tags) {
    final tag = tags.where((tag) => tag[0] == tagName && tag[3] == 'moderator');

    if (tag.isEmpty) {
      return const CommunityModeratorTag(values: []);
    }

    return CommunityModeratorTag(values: tag.map((tag) => tag[1]).toList());
  }

  static const String tagName = 'p';
  static const String roleValue = 'moderator';

  List<List<String>> toTag() {
    return values.map((value) => [tagName, value, '', roleValue]).toList();
  }
}
