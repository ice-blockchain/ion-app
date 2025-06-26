// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/ion_connect/model/related_event.f.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';

mixin EntityDataWithRelatedEvents<T extends RelatedEvent> {
  List<T>? get relatedEvents;

  T? get parentEvent {
    if (relatedEvents == null) return null;

    T? rootParent;
    T? replyParent;
    for (final relatedEvent in relatedEvents!) {
      if (relatedEvent.marker == RelatedEventMarker.reply) {
        replyParent = relatedEvent;
        break;
      } else if (relatedEvent.marker == RelatedEventMarker.root) {
        rootParent = relatedEvent;
      }
    }
    return replyParent ?? rootParent;

    //TODO: Remove code above and uncomment bottom line after release.
    // We need to support looking for a `root` reference modifiers for backward compatibility with already created posts.
    // return relatedEvents?.firstWhereOrNull((event) => event.marker == RelatedEventMarker.reply);
  }

  T? get rootRelatedEvent {
    return relatedEvents?.firstWhereOrNull((tag) => tag.marker == RelatedEventMarker.root);
  }

  static List<RelatedEvent>? fromTags(Map<String, List<List<String>>> tags) {
    final relatedEvents = <RelatedEvent>[
      ...(tags[RelatedImmutableEvent.tagName]?.map(RelatedImmutableEvent.fromTag) ?? []),
      ...(tags[RelatedReplaceableEvent.tagName]?.map(RelatedReplaceableEvent.fromTag) ?? []),
    ];
    return relatedEvents.isEmpty ? null : relatedEvents;
  }
}
