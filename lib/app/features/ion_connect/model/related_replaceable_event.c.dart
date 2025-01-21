// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_reference.c.dart';

part 'related_replaceable_event.c.freezed.dart';

enum RelatedEventMarker { reply, root, mention }

@freezed
class RelatedReplaceableEvent with _$RelatedReplaceableEvent {
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

  List<String> toTag() {
    return [tagName, eventReference.toString(), '', marker.name, pubkey];
  }

  static const String tagName = 'a';
}
