// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/router/app_routes.gr.dart';

GestureRecognizer? customRecognizerBuilder(
  BuildContext context,
  Attribute<dynamic> attribute, {
  bool isEditing = false,
}) {
  if (attribute.key == HashtagAttribute.attributeKey ||
      attribute.key == CashtagAttribute.attributeKey) {
    return TapGestureRecognizer()
      ..onTap = isEditing
          ? null
          : () {
              FeedAdvancedSearchRoute(query: attribute.value as String).go(context);
            };
  }
  return null;
}
