// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'related_relay.f.freezed.dart';

@freezed
class RelatedRelay with _$RelatedRelay {
  const factory RelatedRelay({
    required String url,
  }) = _RelatedRelay;

  const RelatedRelay._();

  factory RelatedRelay.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return RelatedRelay(url: tag[1]);
  }

  static const String tagName = 'relay';

  List<String> toTag() {
    return [tagName, url];
  }
}
