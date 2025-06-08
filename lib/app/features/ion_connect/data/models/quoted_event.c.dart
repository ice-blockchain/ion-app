// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';

part 'quoted_event.c.freezed.dart';

abstract class QuotedEvent {
  factory QuotedEvent.fromTag(List<String> tag) {
    return switch (tag[0]) {
      QuotedReplaceableEvent.tagName => QuotedReplaceableEvent.fromTag(tag),
      QuotedImmutableEvent.tagName => QuotedImmutableEvent.fromTag(tag),
      _ => throw IncorrectEventTagException(tag: tag[0]),
    };
  }

  EventReference get eventReference;

  List<String> toTag();
}

@freezed
class QuotedReplaceableEvent with _$QuotedReplaceableEvent implements QuotedEvent {
  const factory QuotedReplaceableEvent({
    required ReplaceableEventReference eventReference,
  }) = _QuotedReplaceableEvent;

  const QuotedReplaceableEvent._();

  /// https://github.com/ice-blockchain/subzero/blob/master/.ion-connect-protocol/ICIP-01.md#quotes
  factory QuotedReplaceableEvent.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length < 4) {
      throw IncorrectEventTagException(tag: tag.toString());
    }
    return QuotedReplaceableEvent(
      eventReference: ReplaceableEventReference.fromString(tag[1]),
    );
  }

  @override
  List<String> toTag() {
    return [tagName, eventReference.toString(), '', eventReference.pubkey];
  }

  static const String tagName = 'Q';
}

@freezed
class QuotedImmutableEvent with _$QuotedImmutableEvent implements QuotedEvent {
  const factory QuotedImmutableEvent({
    required ImmutableEventReference eventReference,
  }) = _QuotedImmutableEvent;

  const QuotedImmutableEvent._();

  /// https://github.com/nostr-protocol/nips/blob/master/18.md
  factory QuotedImmutableEvent.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length < 4) {
      throw IncorrectEventTagException(tag: tag.toString());
    }
    return QuotedImmutableEvent(
      eventReference: ImmutableEventReference(eventId: tag[1], pubkey: tag[3]),
    );
  }

  @override
  List<String> toTag() {
    return [tagName, eventReference.toString(), '', eventReference.pubkey];
  }

  static const String tagName = 'q';
}
