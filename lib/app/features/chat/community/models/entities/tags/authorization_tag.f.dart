// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'authorization_tag.f.freezed.dart';

@freezed
class AuthorizationTag with _$AuthorizationTag {
  const factory AuthorizationTag({
    required String value,
  }) = _AuthorizationTag;

  const AuthorizationTag._();

  factory AuthorizationTag.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    return AuthorizationTag(
      value: tag[1],
    );
  }

  List<String> toTag() {
    return [tagName, value];
  }

  static const String tagName = 'authorization';
}
