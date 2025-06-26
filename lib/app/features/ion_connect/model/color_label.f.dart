// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'color_label.f.freezed.dart';

@freezed
class ColorLabel with _$ColorLabel {
  const factory ColorLabel({
    required String value,
  }) = _ColorLabel;

  const ColorLabel._();

  List<String> toNamespaceTag() {
    return [namespaceTagName, namespace];
  }

  List<String> toValueTag() {
    return [tagName, value, namespace];
  }

  static ColorLabel? fromTags(Map<String, List<List<String>>> tags, {required String eventId}) {
    final hasNamespaceTag =
        tags[ColorLabel.namespaceTagName]?.any(ColorLabel._isColorNamespace) ?? false;

    if (!hasNamespaceTag) return null;

    final colorTag = tags[ColorLabel.tagName]?.first;

    if (colorTag == null) {
      throw IncorrectEventTagsException(eventId: eventId);
    }

    return ColorLabel(value: colorTag[1]);
  }

  static bool _isColorNamespace(List<String> tag) {
    return tag.length > 1 && tag[0] == namespaceTagName && tag[1] == namespace;
  }

  static const String tagName = 'l';
  static const String namespaceTagName = 'L';
  static const String namespace = 'color';
}
