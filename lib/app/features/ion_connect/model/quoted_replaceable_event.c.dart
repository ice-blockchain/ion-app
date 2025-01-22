// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_reference.c.dart';

part 'quoted_replaceable_event.c.freezed.dart';

@freezed
class QuotedReplaceableEvent with _$QuotedReplaceableEvent {
  const factory QuotedReplaceableEvent({
    required ReplaceableEventReference eventReference,
    required String pubkey,
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
      pubkey: tag[3],
    );
  }

  List<String> toTag() {
    return [tagName, eventReference.toString(), '', pubkey];
  }

  static const String tagName = 'Q';
}
