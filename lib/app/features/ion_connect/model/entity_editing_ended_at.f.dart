// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'entity_editing_ended_at.f.freezed.dart';

@freezed
class EntityEditingEndedAt with _$EntityEditingEndedAt {
  const factory EntityEditingEndedAt({
    required int value,
  }) = _EntityEditingEndedAt;

  const EntityEditingEndedAt._();

  factory EntityEditingEndedAt.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    return EntityEditingEndedAt(
      value: int.parse(tag[1]),
    );
  }

  factory EntityEditingEndedAt.build(int minutes) {
    return EntityEditingEndedAt(
      value: DateTime.now()
          .add(
            Duration(
              minutes: minutes,
            ),
          )
          .microsecondsSinceEpoch,
    );
  }

  List<String> toTag() {
    return [tagName, value.toString()];
  }

  static const String tagName = 'editing_ended_at';
}
