// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';

mixin EntityDataWithRelatedEvents {
  List<RelatedEvent>? get relatedEvents;

  RelatedEvent? get parentEvent {
    return relatedEvents?.firstWhereOrNull((event) => event.marker == RelatedEventMarker.reply);
  }

  static List<RelatedEvent>? fromTags(Map<String, List<List<String>>> tags) {
    final relatedEvents = <RelatedEvent>[
      ...(tags[RelatedImmutableEvent.tagName]?.map(RelatedImmutableEvent.fromTag) ?? []),
      ...(tags[RelatedReplaceableEvent.tagName]?.map(RelatedReplaceableEvent.fromTag) ?? []),
    ];
    return relatedEvents.isEmpty ? null : relatedEvents;
  }
}
