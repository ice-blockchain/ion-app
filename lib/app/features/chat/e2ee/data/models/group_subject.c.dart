// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'group_subject.c.freezed.dart';

@freezed
class GroupSubject with _$GroupSubject {
  const factory GroupSubject(String value) = _GroupSubject;

  const GroupSubject._();

  factory GroupSubject.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length < 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }
    return GroupSubject(tag[1]);
  }

  List<String> toTag() {
    return [tagName, value];
  }

  static const String tagName = 'subject';
}
