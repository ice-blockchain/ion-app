// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_label.c.freezed.dart';

@freezed
class ColorLabel with _$ColorLabel {
  const factory ColorLabel({
    String? value,
  }) = _ColorLabel;

  const ColorLabel._();

  static bool isNamespaceTag(List<String> tag) {
    return tag.length > 1 && tag[0] == namespaceTagName && tag[1] == namespace;
  }

  static bool isValueTag(List<String> tag) {
    return tag.length > 2 && tag[0] == tagName && tag[2] == namespace;
  }

  static String? extractValue(List<String> tag) {
    return isValueTag(tag) ? tag[1] : null;
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
