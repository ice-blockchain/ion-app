// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'quoted_event.c.freezed.dart';

@freezed
class QuotedEvent with _$QuotedEvent {
  const factory QuotedEvent({
    required String eventId,
    required String pubkey,
  }) = _QuotedEvent;

  const QuotedEvent._();

  /// https://github.com/nostr-protocol/nips/blob/master/18.md
  factory QuotedEvent.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length < 4) {
      throw IncorrectEventTagException(tag: tag.toString());
    }
    return QuotedEvent(
      eventId: tag[1],
      pubkey: tag[3],
    );
  }

  List<String> toTag() {
    return [tagName, eventId, '', pubkey];
  }

  static const String tagName = 'q';
}
