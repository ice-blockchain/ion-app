// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_reference.c.dart';

part 'quoted_modifiable_event.c.freezed.dart';

@freezed
class QuotedModifiableEvent with _$QuotedModifiableEvent {
  const factory QuotedModifiableEvent({
    required ReplaceableEventReference eventReference,
    required String pubkey,
  }) = _QuotedModifiableEvent;

  const QuotedModifiableEvent._();

  /// Like a `q` tag, but designed for addressable events
  /// https://github.com/nostr-protocol/nips/blob/master/18.md
  factory QuotedModifiableEvent.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length < 4) {
      throw IncorrectEventTagException(tag: tag.toString());
    }
    return QuotedModifiableEvent(
      eventReference: ReplaceableEventReference.fromString(tag[1]),
      pubkey: tag[3],
    );
  }

  List<String> toTag() {
    return [tagName, eventReference.toString(), '', pubkey];
  }

  static const String tagName = 'Q';
}
