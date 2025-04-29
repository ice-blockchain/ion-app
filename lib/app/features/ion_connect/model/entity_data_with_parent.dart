// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';

mixin EntityDataWithRelatedEvents {
  List<RelatedEvent>? get relatedEvents;

  RelatedEvent? get parentEvent {
    if (relatedEvents == null) return null;

    RelatedEvent? rootReplyId;
    RelatedEvent? replyId;
    for (final relatedEvent in relatedEvents!) {
      if (relatedEvent.marker == RelatedEventMarker.reply) {
        replyId = relatedEvent;
        break;
      } else if (relatedEvent.marker == RelatedEventMarker.root) {
        rootReplyId = relatedEvent;
      }
    }
    return replyId ?? rootReplyId;

    //TODO: Remove code above and uncomment bottom line after release.
    // We need to support looking for a `root` reference modifiers for backward compatibility with already created posts.
    // return relatedEvents?.firstWhereOrNull((event) => event.marker == RelatedEventMarker.reply);
  }

  static List<RelatedEvent>? fromTags(Map<String, List<List<String>>> tags) {
    final relatedEvents = <RelatedEvent>[
      ...(tags[RelatedImmutableEvent.tagName]?.map(RelatedImmutableEvent.fromTag) ?? []),
      ...(tags[RelatedReplaceableEvent.tagName]?.map(RelatedReplaceableEvent.fromTag) ?? []),
    ];
    return relatedEvents.isEmpty ? null : relatedEvents;
  }
}
