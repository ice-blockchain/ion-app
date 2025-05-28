// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'entity_expiration.c.freezed.dart';

@freezed
class EntityExpiration with _$EntityExpiration {
  const factory EntityExpiration({
    required int value,
  }) = _EntityExpiration;

  const EntityExpiration._();

  /// https://github.com/nostr-protocol/nips/blob/master/40.md
  factory EntityExpiration.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    return EntityExpiration(
      value: int.parse(tag[1]),
    );
  }

  List<String> toTag() {
    return [tagName, value.toString()];
  }

  static const String tagName = 'expiration';
}
