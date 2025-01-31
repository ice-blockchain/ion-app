// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';

part 'related_event.c.freezed.dart';

@freezed
class RelatedEvent with _$RelatedEvent {
  const factory RelatedEvent({
    required ImmutableEventReference eventReference,
    required String pubkey,
    required RelatedEventMarker marker,
  }) = _RelatedEvent;

  const RelatedEvent._();

  /// https://github.com/nostr-protocol/nips/blob/master/10.md#marked-e-tags-preferred
  factory RelatedEvent.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    if (tag.length < 5) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return RelatedEvent(
      eventReference: ImmutableEventReference(eventId: tag[1], pubkey: tag[4]),
      marker: RelatedEventMarker.values.byName(tag[3]),
      pubkey: tag[4],
    );
  }

  List<String> toTag() {
    return [tagName, eventReference.eventId, '', marker.name, pubkey];
  }

  static const String tagName = 'e';
}
