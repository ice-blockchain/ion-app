// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'entity_editing_ended_at.c.freezed.dart';

@freezed
class EntityEditingEndedAt with _$EntityEditingEndedAt {
  const factory EntityEditingEndedAt({
    required DateTime value,
  }) = _EntityEditingEndedAt;

  const EntityEditingEndedAt._();

  factory EntityEditingEndedAt.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    return EntityEditingEndedAt(
      value: DateTime.fromMillisecondsSinceEpoch(int.parse(tag[1]) * 1000),
    );
  }

  factory EntityEditingEndedAt.build(int minutes) {
    return EntityEditingEndedAt(
      value: DateTime.now().add(
        Duration(
          minutes: minutes,
        ),
      ),
    );
  }

  List<String> toTag() {
    return [tagName, (value.millisecondsSinceEpoch ~/ 1000).toString()];
  }

  static const String tagName = 'editing_ended_at';
}
