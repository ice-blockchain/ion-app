// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'color_label.c.freezed.dart';

@freezed
class ColorLabel with _$ColorLabel {
  const factory ColorLabel({
    String? value,
  }) = _ColorLabel;

  const ColorLabel._();

  /// https://github.com/nostr-protocol/nips/blob/master/32.md
  factory ColorLabel.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length < 3 || tag[2] != namespace) {
      throw IncorrectEventTagException(tag: tag.toString());
    }
    return ColorLabel(value: tag[1]);
  }

  List<String> toNamespaceTag() {
    return [namespaceTagName, namespace];
  }

  List<String> toValueTag() {
    return [tagName, value ?? '', namespace];
  }

  static const String tagName = 'l';
  static const String namespaceTagName = 'L';
  static const String namespace = 'color';
}
