// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'conversation_identifier.c.freezed.dart';

@freezed
class ConversationIdentifier with _$ConversationIdentifier {
  const factory ConversationIdentifier({
    required String value,
  }) = _ConversationIdentifier;

  const ConversationIdentifier._();

  factory ConversationIdentifier.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return ConversationIdentifier(value: tag[1]);
  }

  static const String tagName = 'h';

  List<String> toTag() {
    return [tagName, value];
  }
}
