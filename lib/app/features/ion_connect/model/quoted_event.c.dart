// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

part 'quoted_event.c.freezed.dart';

@freezed
class QuotedEvent with _$QuotedEvent {
  const factory QuotedEvent({
    required ImmutableEventReference eventReference,
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
      eventReference: ImmutableEventReference(eventId: tag[1], pubkey: tag[3]),
    );
  }

  List<String> toTag() {
    return [tagName, eventReference.eventId, '', eventReference.pubkey];
  }

  static const String tagName = 'q';
}
