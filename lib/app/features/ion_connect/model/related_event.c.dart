// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';

part 'related_event.c.freezed.dart';

abstract class RelatedEvent {
  factory RelatedEvent.fromTag(List<String> tag) {
    return switch (tag[0]) {
      RelatedImmutableEvent.tagName => RelatedImmutableEvent.fromTag(tag),
      RelatedReplaceableEvent.tagName => RelatedReplaceableEvent.fromTag(tag),
      _ => throw IncorrectEventTagException(tag: tag[0]),
    };
  }

  EventReference get eventReference;

  RelatedEventMarker get marker;

  List<String> toTag();
}

@freezed
class RelatedImmutableEvent with _$RelatedImmutableEvent implements RelatedEvent {
  const factory RelatedImmutableEvent({
    required ImmutableEventReference eventReference,
    required String pubkey,
    required RelatedEventMarker marker,
  }) = _RelatedImmutableEvent;

  const RelatedImmutableEvent._();

  /// https://github.com/nostr-protocol/nips/blob/master/10.md#marked-e-tags-preferred
  factory RelatedImmutableEvent.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    if (tag.length < 5) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return RelatedImmutableEvent(
      eventReference: ImmutableEventReference(eventId: tag[1], pubkey: tag[4]),
      marker: RelatedEventMarker.values.byName(tag[3]),
      pubkey: tag[4],
    );
  }

  @override
  List<String> toTag() {
    return [tagName, eventReference.eventId, '', marker.name, pubkey];
  }

  static const String tagName = 'e';
}

@freezed
class RelatedReplaceableEvent with _$RelatedReplaceableEvent implements RelatedEvent {
  const factory RelatedReplaceableEvent({
    required ReplaceableEventReference eventReference,
    required String pubkey,
    required RelatedEventMarker marker,
  }) = _RelatedReplaceableEvent;

  const RelatedReplaceableEvent._();

  /// https://github.com/ice-blockchain/subzero/blob/master/.ion-connect-protocol/ICIP-01.md#replies
  factory RelatedReplaceableEvent.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    if (tag.length < 5) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return RelatedReplaceableEvent(
      eventReference: ReplaceableEventReference.fromString(tag[1]),
      marker: RelatedEventMarker.values.byName(tag[3]),
      pubkey: tag[4],
    );
  }

  @override
  List<String> toTag() {
    return [tagName, eventReference.toString(), '', marker.name, pubkey];
  }

  static const String tagName = 'a';
}
