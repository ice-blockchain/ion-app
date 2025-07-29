// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';

part 'source_post_reference.f.freezed.dart';

@freezed
class SourcePostReference with _$SourcePostReference {
  const factory SourcePostReference({
    required EventReference eventReference,
    RelatedEventMarker? marker,
  }) = _SourcePostReference;

  const SourcePostReference._();

  /// Parses source post reference from "a" tag with format:
  /// ["a", "30175:pubkey:id"] or
  /// ["a", "30175:pubkey:id", ""] or
  /// ["a", "30175:pubkey:id", "", "mention"]
  factory SourcePostReference.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    if (tag.length < 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    final markerString = tag.length >= 4 ? tag[3] : null;
    final marker = RelatedEventMarker.fromValue(markerString);

    // Only parse tags with "mention" marker
    if (marker != RelatedEventMarker.mention) {
      throw IncorrectEventTagException(tag: 'SourcePostReference requires mention marker');
    }

    return SourcePostReference(
      eventReference: ReplaceableEventReference.fromString(tag[1]),
      marker: marker,
    );
  }

  static const String tagName = 'a';

  List<String> toTag() {
    return [tagName, eventReference.toString(), '', marker?.toValue() ?? 'mention'];
  }

  /// Check if a tag is a source post reference (has "mention" marker)
  static bool isSourcePostTag(List<String> tag) {
    if (tag.isEmpty || tag[0] != tagName) return false;
    if (tag.length < 2) return false;

    // Check if it has explicit "mention" marker
    final markerString = tag.length >= 4 ? tag[3] : null;
    final marker = RelatedEventMarker.fromValue(markerString);
    return marker == RelatedEventMarker.mention;
  }

  static SourcePostReference? fromTags(List<List<String>> tags) {
    for (final tag in tags) {
      if (isSourcePostTag(tag)) {
        return SourcePostReference.fromTag(tag);
      }
    }
    return null;
  }
}
