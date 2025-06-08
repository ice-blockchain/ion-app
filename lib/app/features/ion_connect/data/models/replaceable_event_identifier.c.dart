// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/services/uuid/uuid.dart';

part 'replaceable_event_identifier.c.freezed.dart';

@freezed
class ReplaceableEventIdentifier with _$ReplaceableEventIdentifier {
  const factory ReplaceableEventIdentifier({
    required String value,
  }) = _ReplaceableEventIdentifier;

  const ReplaceableEventIdentifier._();

  factory ReplaceableEventIdentifier.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length < 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }
    return ReplaceableEventIdentifier(value: tag[1]);
  }

  factory ReplaceableEventIdentifier.generate() {
    return ReplaceableEventIdentifier(value: generateUuid());
  }

  List<String> toTag() {
    return [tagName, value];
  }

  static const String tagName = 'd';
}
