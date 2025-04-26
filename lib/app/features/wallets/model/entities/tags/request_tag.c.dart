// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'request_tag.c.freezed.dart';

@freezed
class RequestTag with _$RequestTag {
  const factory RequestTag({
    required String value,
  }) = _RequestTag;

  const RequestTag._();

  factory RequestTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length != 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    return RequestTag(value: tag[1]);
  }

  static const String tagName = 'request';

  List<String> toTag() {
    return [tagName, value];
  }
}
