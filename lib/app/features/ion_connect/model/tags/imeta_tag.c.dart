import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';

part 'imeta_tag.c.freezed.dart';

@freezed
class ImetaTag with _$ImetaTag {
  const factory ImetaTag({
    required MediaAttachment? value,
  }) = _ImetaTag;

  factory ImetaTag.fromTags(List<List<String>> tags) {
    final tag = tags.firstWhereOrNull((tag) => tag[0] == tagName);

    if (tag == null) {
      return const ImetaTag(value: null);
    }

    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    return ImetaTag(value: MediaAttachment.fromTag(tag));
  }

  static const String tagName = 'imeta';

  List<String>? toTag() {
    return value == null ? null : [tagName, ...value!.toTag()];
  }
}
