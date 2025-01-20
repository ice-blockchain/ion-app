// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'entity_published_at.c.freezed.dart';

@freezed
class EntityPublishedAt with _$EntityPublishedAt {
  const factory EntityPublishedAt({
    required DateTime value,
  }) = _EntityPublishedAt;

  const EntityPublishedAt._();

  factory EntityPublishedAt.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    return EntityPublishedAt(
      value: DateTime.fromMillisecondsSinceEpoch(int.parse(tag[1]) * 1000),
    );
  }

  List<String> toTag() {
    return [tagName, (value.millisecondsSinceEpoch ~/ 1000).toString()];
  }

  static const String tagName = 'published_at';
}
