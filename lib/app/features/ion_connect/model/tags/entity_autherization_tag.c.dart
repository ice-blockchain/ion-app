// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'entity_autherization_tag.c.freezed.dart';

@freezed
class EntityAutherization with _$EntityAutherization {
  const factory EntityAutherization({
    required String value,
  }) = _EntityAutherization;

  const EntityAutherization._();

  /// https://github.com/nostr-protocol/nips/blob/master/40.md
  factory EntityAutherization.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    return EntityAutherization(
      value: tag[1],
    );
  }

  List<String> toTag() {
    return [tagName, value];
  }

  static const String tagName = 'authorization';
}
