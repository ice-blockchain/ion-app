import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'related_event.freezed.dart';

enum RelatedEventMarker { reply, root, mention }

@freezed
class RelatedEvent with _$RelatedEvent {
  const factory RelatedEvent({
    required String eventId,
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
      eventId: tag[1],
      marker: RelatedEventMarker.values.byName(tag[3]),
      pubkey: tag[4],
    );
  }

  List<String> toTag() {
    return [tagName, eventId, '', marker.name, pubkey];
  }

  static const String tagName = 'e';
}
