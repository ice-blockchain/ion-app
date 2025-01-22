// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'replaceable_event_reference.c.freezed.dart';

@Freezed(toStringOverride: false)
class ReplaceableEventReference with _$ReplaceableEventReference {
  const factory ReplaceableEventReference({
    required int kind,
    required String pubkey,
    String? dTag,
  }) = _ReplaceableEventReference;

  const ReplaceableEventReference._();

  factory ReplaceableEventReference.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    return ReplaceableEventReference.fromString(tag[1]);
  }

  factory ReplaceableEventReference.fromString(String input) {
    final parts = input.split(separator);

    return ReplaceableEventReference(
      kind: int.parse(parts[0]),
      pubkey: parts[1],
      dTag: parts.elementAtOrNull(2),
    );
  }

  List<String> toTag() {
    return [tagName, toString()];
  }

  @override
  String toString() {
    return [kind, pubkey, dTag].nonNulls.join(separator);
  }

  static const String separator = ':';

  static const String tagName = 'a';
}
