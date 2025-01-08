// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/services/logger/logger.dart';

void toggleHeaderStyle(QuillController controller, Attribute<dynamic> headerAttribute) {
  final currentStyle = controller.getSelectionStyle();

  final isSameHeaderStyle =
      currentStyle.attributes[headerAttribute.key]?.value == headerAttribute.value;

  wipeAllStyles(controller);

  if (!isSameHeaderStyle) {
    controller.formatSelection(headerAttribute);
  }
}

void toggleTextStyle(QuillController controller, Attribute<dynamic> textAttribute) {
  final currentStyle = controller.getSelectionStyle();

  final mutuallyExclusiveStyles = [Attribute.bold.key, Attribute.italic.key];

  Logger.log('currentStyle.attributes: ${currentStyle.attributes}');
  final hasHeaderOrLink = currentStyle.attributes.keys.any(
    (key) => ['h1', 'h2', 'h3', Attribute.link.key].contains(key),
  );

  if (hasHeaderOrLink) {
    wipeAllStyles(controller, retainStyles: {Attribute.underline.key});
    controller.formatSelection(textAttribute);
    return;
  }

  if (mutuallyExclusiveStyles.contains(textAttribute.key)) {
    toggleRegularStyle(controller);
    for (final key in mutuallyExclusiveStyles) {
      if (currentStyle.attributes.containsKey(key) && key != textAttribute.key) {
        final attribute = Attribute.fromKeyValue(key, null);
        if (attribute != null) {
          controller.formatSelection(Attribute.clone(attribute, null));
        }
      }
    }
  }

  if (currentStyle.attributes.containsKey(textAttribute.key)) {
    controller.formatSelection(Attribute.clone(textAttribute, null));
  } else {
    controller.formatSelection(textAttribute);
  }
}

void toggleLinkStyle(QuillController controller, String? link) {
  if (link == null || link.isEmpty) {
    wipeAllStyles(controller);
    controller.formatSelection(const LinkAttribute(null));
  } else {
    wipeAllStyles(controller, retainStyles: {Attribute.link.key});
    controller.formatSelection(LinkAttribute(link));
  }
}

void toggleRegularStyle(QuillController controller) {
  controller
    ..formatSelection(Attribute.clone(Attribute.h1, null))
    ..formatSelection(Attribute.clone(Attribute.h2, null))
    ..formatSelection(Attribute.clone(Attribute.h3, null));
}

void wipeAllStyles(QuillController controller, {Set<String> retainStyles = const {}}) {
  final allStyles = {
    Attribute.bold.key: Attribute.bold,
    Attribute.italic.key: Attribute.italic,
    Attribute.underline.key: Attribute.underline,
    Attribute.link.key: Attribute.link,
    Attribute.h1.key: Attribute.h1,
    Attribute.h2.key: Attribute.h2,
    Attribute.h3.key: Attribute.h3,
  };

  for (final entry in allStyles.entries) {
    if (!retainStyles.contains(entry.key)) {
      final attribute = entry.value as Attribute<dynamic>;
      controller.formatSelection(Attribute.clone(attribute, null));
    }
  }
}
