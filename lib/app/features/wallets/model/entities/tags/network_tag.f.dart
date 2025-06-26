// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'network_tag.f.freezed.dart';

@freezed
class NetworkTag with _$NetworkTag {
  const factory NetworkTag({
    required String value,
  }) = _NetworkTag;

  const NetworkTag._();

  factory NetworkTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return NetworkTag(value: tag[1]);
  }

  static const String tagName = 'network';

  List<String> toTag() {
    return [tagName, value];
  }
}
