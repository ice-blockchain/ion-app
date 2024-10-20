// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/flutter_quill.dart';

void wipeAllStyles(QuillController controller) {
  controller
    ..formatSelection(Attribute.clone(Attribute.bold, null))
    ..formatSelection(Attribute.clone(Attribute.italic, null))
    ..formatSelection(Attribute.clone(Attribute.h1, null))
    ..formatSelection(Attribute.clone(Attribute.h2, null))
    ..formatSelection(Attribute.clone(Attribute.h3, null))
    ..formatSelection(Attribute.clone(Attribute.underline, null))
    ..formatSelection(Attribute.clone(Attribute.link, null));
}
