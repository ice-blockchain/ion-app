import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/router/app_routes.c.dart';

GestureRecognizer? customRecognizerBuilder(
  BuildContext context,
  Attribute<dynamic> attribute,
) {
  if (attribute.key == HashtagAttribute.attributeKey) {
    return TapGestureRecognizer()
      ..onTap = () {
        FeedAdvancedSearchRoute(query: attribute.value as String).go(context);
      };
  }
  return null;
}
