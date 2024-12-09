// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion/app/features/nostr/model/media_attachment.dart';

extension ListExtension<T> on List<T>? {
  List<T> get emptyOrValue => this ?? <T>[];

  Type get genericType => T;
}

extension ListRandomExtension<T> on List<T> {
  T get random {
    return this[Random().nextInt(length)];
  }
}

extension ImetaParser on List<List<String>>? {
  Map<String, MediaAttachment> parseImeta() {
    if (this == null) {
      return {};
    }

    final imeta = <String, MediaAttachment>{};
    for (final tag in this!) {
      if (tag[0] == 'imeta') {
        final mediaAttachment = MediaAttachment.fromTag(tag);
        imeta[mediaAttachment.url] = mediaAttachment;
      }
    }
    return imeta;
  }
}
