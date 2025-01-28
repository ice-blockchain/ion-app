import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'community_identifer_tag.c.freezed.dart';

@freezed
class CommunityIdentifierTag with _$CommunityIdentifierTag {
  const factory CommunityIdentifierTag({
    required String value,
  }) = _CommunityIdentifierTag;

  const CommunityIdentifierTag._();

  factory CommunityIdentifierTag.fromTags(List<List<String>> tags) {
    final tag = tags.firstWhere((tag) => tag[0] == tagName);

    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return CommunityIdentifierTag(value: tag[1]);
  }

  static const String tagName = 'h';

  List<String> toTag() {
    return [tagName, value];
  }
}
