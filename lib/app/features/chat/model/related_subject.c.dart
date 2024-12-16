// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'related_subject.c.freezed.dart';

@freezed
class RelatedSubject with _$RelatedSubject {
  const factory RelatedSubject({required String value}) = _RelatedSubject;

  const RelatedSubject._();

  factory RelatedSubject.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length < 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }
    return RelatedSubject(value: tag[1]);
  }

  List<String> toTag() {
    return [tagName, value];
  }

  static const String tagName = 'subject';
}
