// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'event_reference.c.freezed.dart';

abstract class EventReference {
  factory EventReference.fromEncoded(String input) {
    final parts = input.split(separator);
    return switch (parts[0]) {
      ImmutableEventReference.tagName => ImmutableEventReference.fromEncoded(input),
      ReplaceableEventReference.tagName => ReplaceableEventReference.fromEncoded(input),
      _ => throw UnknownEventReferenceType(type: parts[0]),
    };
  }

  String get pubkey;

  String encode();

  List<String> toTag();

  MapEntry<String, List<String>> toFilterEntry();

  static String separator = ':';
}

@Freezed(toStringOverride: false)
class ImmutableEventReference with _$ImmutableEventReference implements EventReference {
  const factory ImmutableEventReference({
    required String pubkey,
    required String eventId,
  }) = _ImmutableEventReference;

  const ImmutableEventReference._();

  // TODO: use https://github.com/nostr-protocol/nips/blob/master/19.md#shareable-identifiers-with-extra-metadata ?
  factory ImmutableEventReference.fromEncoded(String input) {
    final parts = input.split(EventReference.separator);

    if (parts[0] != tagName) {
      throw UnknownEventReferenceType(type: parts[0]);
    }

    return ImmutableEventReference(eventId: parts[1], pubkey: parts[2]);
  }

  @override
  List<String> toTag() {
    return [tagName, eventId];
  }

  @override
  String encode() {
    return [tagName, eventId, pubkey].join(EventReference.separator);
  }

  @override
  MapEntry<String, List<String>> toFilterEntry() {
    return MapEntry('#$tagName', [eventId]);
  }

  @override
  String toString() {
    return [eventId, pubkey].nonNulls.join(EventReference.separator);
  }

  static const String tagName = 'e';
}

@Freezed(toStringOverride: false)
class ReplaceableEventReference with _$ReplaceableEventReference implements EventReference {
  const factory ReplaceableEventReference({
    required String pubkey,
    required int kind,
    String? dTag,
  }) = _ReplaceableEventReference;

  const ReplaceableEventReference._();

  factory ReplaceableEventReference.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    return ReplaceableEventReference.fromString(tag[1]);
  }

  factory ReplaceableEventReference.fromEncoded(String input) {
    final parts = input.split(EventReference.separator);

    if (parts[0] != tagName) {
      throw UnknownEventReferenceType(type: parts[0]);
    }

    return ReplaceableEventReference(
      kind: int.parse(parts[1]),
      pubkey: parts[2],
      dTag: parts.elementAtOrNull(3),
    );
  }

  factory ReplaceableEventReference.fromString(String input) {
    final parts = input.split(EventReference.separator);

    return ReplaceableEventReference(
      kind: int.parse(parts[0]),
      pubkey: parts[1],
      dTag: parts.elementAtOrNull(2),
    );
  }

  @override
  List<String> toTag() {
    return [
      tagName,
      [kind, pubkey, dTag].nonNulls.join(EventReference.separator),
    ];
  }

  @override
  String encode() {
    return [tagName, kind, pubkey, dTag].nonNulls.join(EventReference.separator);
  }

  @override
  MapEntry<String, List<String>> toFilterEntry() {
    return MapEntry('#$tagName', [toString()]);
  }

  @override
  String toString() {
    return [kind, pubkey, dTag].nonNulls.join(EventReference.separator);
  }

  static const String tagName = 'a';
}
